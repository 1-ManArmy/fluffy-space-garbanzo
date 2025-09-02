# frozen_string_literal: true

# Keycloak Authentication Service for OneLastAI
# Replacing Passage auth with Red Hat Keycloak (RHSSO)

require 'httparty'
require 'jwt'

class KeycloakAuthService
  include HTTParty
  
  def initialize
    @keycloak_url = ENV['KEYCLOAK_URL'] || 'http://localhost:8081'
    @realm = ENV['KEYCLOAK_REALM'] || 'onelastai'
    @client_id = ENV['KEYCLOAK_CLIENT_ID'] || 'onelastai-web'
    @client_secret = ENV['KEYCLOAK_CLIENT_SECRET']
    @admin_username = ENV['KEYCLOAK_ADMIN_USERNAME'] || 'admin'
    @admin_password = ENV['KEYCLOAK_ADMIN_PASSWORD']
    
    @base_url = "#{@keycloak_url}/realms/#{@realm}"
    @admin_base_url = "#{@keycloak_url}/admin/realms/#{@realm}"
    
    validate_configuration!
  end

  # =============================================================================
  # AUTHENTICATION METHODS
  # =============================================================================

  # Authenticate user with username/password
  def authenticate_user(username, password)
    payload = {
      grant_type: 'password',
      client_id: @client_id,
      client_secret: @client_secret,
      username: username,
      password: password,
      scope: 'openid profile email'
    }

    response = self.class.post("#{@base_url}/protocol/openid-connect/token", {
      body: payload,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
    })

    handle_auth_response(response)
  end

  # Refresh access token
  def refresh_token(refresh_token)
    payload = {
      grant_type: 'refresh_token',
      client_id: @client_id,
      client_secret: @client_secret,
      refresh_token: refresh_token
    }

    response = self.class.post("#{@base_url}/protocol/openid-connect/token", {
      body: payload,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
    })

    handle_auth_response(response)
  end

  # Verify and decode JWT token
  def verify_token(access_token)
    begin
      # Get public key from Keycloak
      public_key = get_realm_public_key
      
      # Decode and verify JWT
      payload = JWT.decode(access_token, public_key, true, { 
        algorithm: 'RS256',
        iss: @base_url,
        verify_iss: true,
        aud: @client_id,
        verify_aud: true
      })

      {
        valid: true,
        user_id: payload[0]['sub'],
        username: payload[0]['preferred_username'],
        email: payload[0]['email'],
        roles: payload[0]['realm_access']['roles'] || [],
        expires_at: Time.at(payload[0]['exp'])
      }
    rescue JWT::DecodeError => e
      Rails.logger.warn "JWT decode error: #{e.message}"
      { valid: false, error: 'Invalid token' }
    rescue => e
      Rails.logger.error "Token verification error: #{e.message}"
      { valid: false, error: 'Token verification failed' }
    end
  end

  # Logout user
  def logout_user(refresh_token)
    payload = {
      client_id: @client_id,
      client_secret: @client_secret,
      refresh_token: refresh_token
    }

    response = self.class.post("#{@base_url}/protocol/openid-connect/logout", {
      body: payload,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
    })

    response.code == 204
  end

  # =============================================================================
  # USER MANAGEMENT METHODS
  # =============================================================================

  # Create new user
  def create_user(user_data)
    admin_token = get_admin_token
    
    payload = {
      username: user_data[:username],
      email: user_data[:email],
      firstName: user_data[:first_name],
      lastName: user_data[:last_name],
      enabled: true,
      emailVerified: user_data[:email_verified] || false,
      attributes: user_data[:attributes] || {}
    }

    # Add password if provided
    if user_data[:password]
      payload[:credentials] = [{
        type: 'password',
        value: user_data[:password],
        temporary: user_data[:temporary_password] || false
      }]
    end

    response = self.class.post("#{@admin_base_url}/users", {
      body: payload.to_json,
      headers: admin_headers(admin_token)
    })

    handle_admin_response(response)
  end

  # Get user by ID
  def get_user(user_id)
    admin_token = get_admin_token
    
    response = self.class.get("#{@admin_base_url}/users/#{user_id}", {
      headers: admin_headers(admin_token)
    })

    handle_admin_response(response)
  end

  # Update user
  def update_user(user_id, user_data)
    admin_token = get_admin_token
    
    response = self.class.put("#{@admin_base_url}/users/#{user_id}", {
      body: user_data.to_json,
      headers: admin_headers(admin_token)
    })

    handle_admin_response(response)
  end

  # Delete user
  def delete_user(user_id)
    admin_token = get_admin_token
    
    response = self.class.delete("#{@admin_base_url}/users/#{user_id}", {
      headers: admin_headers(admin_token)
    })

    response.code == 204
  end

  # Search users
  def search_users(query, options = {})
    admin_token = get_admin_token
    
    params = {
      search: query,
      first: options[:offset] || 0,
      max: options[:limit] || 20
    }

    response = self.class.get("#{@admin_base_url}/users", {
      query: params,
      headers: admin_headers(admin_token)
    })

    handle_admin_response(response)
  end

  # =============================================================================
  # ROLE MANAGEMENT METHODS
  # =============================================================================

  # Assign role to user
  def assign_role_to_user(user_id, role_name)
    admin_token = get_admin_token
    
    # Get role details
    role = get_realm_role(role_name)
    return false unless role

    response = self.class.post("#{@admin_base_url}/users/#{user_id}/role-mappings/realm", {
      body: [role].to_json,
      headers: admin_headers(admin_token)
    })

    response.code == 204
  end

  # Remove role from user
  def remove_role_from_user(user_id, role_name)
    admin_token = get_admin_token
    
    # Get role details
    role = get_realm_role(role_name)
    return false unless role

    response = self.class.delete("#{@admin_base_url}/users/#{user_id}/role-mappings/realm", {
      body: [role].to_json,
      headers: admin_headers(admin_token)
    })

    response.code == 204
  end

  # Get user roles
  def get_user_roles(user_id)
    admin_token = get_admin_token
    
    response = self.class.get("#{@admin_base_url}/users/#{user_id}/role-mappings/realm", {
      headers: admin_headers(admin_token)
    })

    handle_admin_response(response)
  end

  # =============================================================================
  # SSO AND INTEGRATION METHODS
  # =============================================================================

  # Get OAuth authorization URL
  def get_authorization_url(redirect_uri, state = nil)
    params = {
      client_id: @client_id,
      redirect_uri: redirect_uri,
      response_type: 'code',
      scope: 'openid profile email',
      state: state || SecureRandom.urlsafe_base64(32)
    }

    "#{@base_url}/protocol/openid-connect/auth?" + params.to_query
  end

  # Exchange authorization code for tokens
  def exchange_code_for_tokens(code, redirect_uri)
    payload = {
      grant_type: 'authorization_code',
      client_id: @client_id,
      client_secret: @client_secret,
      code: code,
      redirect_uri: redirect_uri
    }

    response = self.class.post("#{@base_url}/protocol/openid-connect/token", {
      body: payload,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
    })

    handle_auth_response(response)
  end

  # Get user info from access token
  def get_user_info(access_token)
    response = self.class.get("#{@base_url}/protocol/openid-connect/userinfo", {
      headers: { 'Authorization' => "Bearer #{access_token}" }
    })

    handle_auth_response(response)
  end

  # =============================================================================
  # AGENT SUBDOMAIN INTEGRATION
  # =============================================================================

  # Verify token for agent subdomain access
  def verify_agent_access(access_token, agent_name, subdomain)
    token_data = verify_token(access_token)
    return false unless token_data[:valid]

    # Check if user has permission for this agent
    has_agent_permission?(token_data, agent_name, subdomain)
  end

  # Check agent permissions based on user roles
  def has_agent_permission?(token_data, agent_name, subdomain)
    user_roles = token_data[:roles] || []
    
    # Admin can access all agents
    return true if user_roles.include?('admin')
    
    # Premium users can access all agents
    return true if user_roles.include?('premium_user')
    
    # Standard users can access basic agents
    basic_agents = %w[neochat emotisense contentcrafter taskmaster]
    return true if user_roles.include?('user') && basic_agents.include?(agent_name)
    
    # Enterprise users can access technical agents
    enterprise_agents = %w[configai authwise infoseek netscope spylens]
    return true if user_roles.include?('enterprise_user') && enterprise_agents.include?(agent_name)
    
    false
  end

  # =============================================================================
  # HEALTH AND CONFIGURATION
  # =============================================================================

  # Check Keycloak server health
  def health_check
    begin
      response = self.class.get("#{@keycloak_url}/health/ready", {
        timeout: 5
      })
      
      {
        healthy: response.code == 200,
        status: response.code,
        message: response.code == 200 ? 'Keycloak is healthy' : 'Keycloak is not responding'
      }
    rescue => e
      {
        healthy: false,
        status: 'error',
        message: "Keycloak health check failed: #{e.message}"
      }
    end
  end

  # Get realm configuration
  def get_realm_info
    response = self.class.get("#{@base_url}/.well-known/openid_configuration")
    handle_auth_response(response)
  end

  private

  # =============================================================================
  # PRIVATE HELPER METHODS
  # =============================================================================

  def validate_configuration!
    missing_configs = []
    missing_configs << 'KEYCLOAK_URL' if @keycloak_url.blank?
    missing_configs << 'KEYCLOAK_REALM' if @realm.blank?
    missing_configs << 'KEYCLOAK_CLIENT_ID' if @client_id.blank?
    missing_configs << 'KEYCLOAK_CLIENT_SECRET' if @client_secret.blank?

    unless missing_configs.empty?
      raise ConfigurationError, "Missing Keycloak configuration: #{missing_configs.join(', ')}"
    end
  end

  def get_admin_token
    payload = {
      grant_type: 'password',
      client_id: 'admin-cli',
      username: @admin_username,
      password: @admin_password
    }

    response = self.class.post("#{@keycloak_url}/realms/master/protocol/openid-connect/token", {
      body: payload,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
    })

    result = handle_auth_response(response)
    result[:access_token]
  end

  def get_realm_public_key
    # Cache public key for performance
    @public_key ||= begin
      response = self.class.get("#{@base_url}/protocol/openid-connect/certs")
      certs_data = JSON.parse(response.body)
      
      # Get the first key (assuming RS256)
      key_data = certs_data['keys'].first
      
      # Convert JWK to PEM format
      jwk_to_pem(key_data)
    end
  end

  def jwk_to_pem(jwk)
    # This is a simplified JWK to PEM conversion
    # In production, use a proper JWT library like ruby-jwt with JWK support
    require 'openssl'
    require 'base64'
    
    n = Base64.urlsafe_decode64(jwk['n'])
    e = Base64.urlsafe_decode64(jwk['e'])
    
    key = OpenSSL::PKey::RSA.new
    key.n = OpenSSL::BN.new(n, 2)
    key.e = OpenSSL::BN.new(e, 2)
    
    key
  end

  def get_realm_role(role_name)
    admin_token = get_admin_token
    
    response = self.class.get("#{@admin_base_url}/roles/#{role_name}", {
      headers: admin_headers(admin_token)
    })

    return nil unless response.code == 200
    JSON.parse(response.body)
  end

  def admin_headers(admin_token)
    {
      'Authorization' => "Bearer #{admin_token}",
      'Content-Type' => 'application/json'
    }
  end

  def handle_auth_response(response)
    case response.code
    when 200
      JSON.parse(response.body).symbolize_keys
    when 401
      raise AuthenticationError, 'Invalid credentials'
    when 400
      error_data = JSON.parse(response.body)
      raise ValidationError, error_data['error_description'] || 'Bad request'
    else
      raise APIError, "HTTP #{response.code}: #{response.body}"
    end
  end

  def handle_admin_response(response)
    case response.code
    when 200, 201
      response.body.present? ? JSON.parse(response.body) : {}
    when 204
      true
    when 404
      raise NotFoundError, 'Resource not found'
    when 401, 403
      raise AuthenticationError, 'Insufficient permissions'
    else
      raise APIError, "HTTP #{response.code}: #{response.body}"
    end
  end

  # Custom exception classes
  class KeycloakError < StandardError; end
  class ConfigurationError < KeycloakError; end
  class AuthenticationError < KeycloakError; end
  class ValidationError < KeycloakError; end
  class NotFoundError < KeycloakError; end
  class APIError < KeycloakError; end
end
