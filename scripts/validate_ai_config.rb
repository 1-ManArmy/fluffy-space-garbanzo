#!/usr/bin/env ruby
# AI Models Configuration Validator
# This script validates the AI models configuration file

require 'yaml'
require 'json'

def validate_ai_models_config(config_path = 'config/ai_models_config.yml')
  puts "=== AI Models Configuration Validator ==="
  puts "Validating: #{config_path}"
  puts

  begin
    # Load and parse YAML
    config = YAML.load_file(config_path)
    puts "✅ YAML syntax is valid"
    
    # Validate structure
    errors = []
    warnings = []
    
    # Check main sections
    required_sections = ['ai_models', 'model_selection', 'resource_management', 'monitoring']
    required_sections.each do |section|
      unless config[section]
        errors << "Missing required section: #{section}"
      end
    end
    
    # Validate AI models section
    if config['ai_models']
      local_models = config['ai_models']['local_models']
      cloud_models = config['ai_models']['cloud_models']
      
      if local_models
        puts "📊 Found #{local_models.keys.length} local models"
        
        local_models.each do |model_name, model_config|
          # Check required fields
          required_fields = ['name', 'size', 'port', 'endpoint', 'capabilities', 'memory_requirement']
          required_fields.each do |field|
            unless model_config[field]
              errors << "Model #{model_name} missing required field: #{field}"
            end
          end
          
          # Validate port numbers
          port = model_config['port']
          if port && (port < 11434 || port > 11450)
            warnings << "Model #{model_name} port #{port} outside recommended range (11434-11450)"
          end
          
          # Check for duplicate ports
          other_models = local_models.reject { |k, v| k == model_name }
          if other_models.any? { |k, v| v['port'] == port }
            errors << "Duplicate port #{port} for model #{model_name}"
          end
        end
      end
      
      if cloud_models
        puts "☁️  Found #{cloud_models.keys.length} cloud model providers"
        
        cloud_models.each do |provider, config|
          unless config['models'] && config['endpoint']
            errors << "Cloud provider #{provider} missing models or endpoint"
          end
          
          unless config['api_key_env']
            warnings << "Cloud provider #{provider} missing API key environment variable"
          end
        end
      end
    end
    
    # Validate model selection
    if config['model_selection']
      mappings = config['model_selection']['agent_mappings']
      if mappings
        puts "🤖 Found #{mappings.keys.length} agent mappings"
        
        # Check for agents without model mappings
        mappings.each do |agent, models|
          if models.empty?
            warnings << "Agent #{agent} has no model mappings"
          end
          
          # Validate model references
          models.each do |model|
            if model.include?(':')
              # Cloud model reference
              provider, model_name = model.split(':', 2)
              unless config['ai_models']['cloud_models']&.[](provider)
                errors << "Agent #{agent} references unknown cloud provider: #{provider}"
              end
            else
              # Local model reference
              unless config['ai_models']['local_models']&.[](model)
                errors << "Agent #{agent} references unknown local model: #{model}"
              end
            end
          end
        end
      end
    end
    
    # Validate resource management
    if config['resource_management']
      memory_limit = config['resource_management']['memory_limit_per_model']
      if memory_limit && memory_limit.to_s.include?('20GB')
        warnings << "Memory limit per model (#{memory_limit}) might be too high for development"
      end
      
      max_requests = config['resource_management']['max_concurrent_requests']
      if max_requests && max_requests > 10
        warnings << "Max concurrent requests (#{max_requests}) might be too high for single machine"
      end
    end
    
    # Report results
    puts
    puts "=== Validation Results ==="
    
    if errors.empty?
      puts "✅ Configuration is valid!"
    else
      puts "❌ Found #{errors.length} error(s):"
      errors.each { |error| puts "   - #{error}" }
    end
    
    if warnings.any?
      puts "⚠️  Found #{warnings.length} warning(s):"
      warnings.each { |warning| puts "   - #{warning}" }
    end
    
    puts
    puts "=== Configuration Summary ==="
    if config['ai_models']['local_models']
      puts "Local Models: #{config['ai_models']['local_models'].keys.join(', ')}"
    end
    if config['ai_models']['cloud_models']
      puts "Cloud Providers: #{config['ai_models']['cloud_models'].keys.join(', ')}"
    end
    if config['model_selection']['agent_mappings']
      puts "Configured Agents: #{config['model_selection']['agent_mappings'].keys.length}"
    end
    
    return errors.empty?
    
  rescue Psych::SyntaxError => e
    puts "❌ YAML Syntax Error:"
    puts "   #{e.message}"
    return false
  rescue => e
    puts "❌ Validation Error:"
    puts "   #{e.message}"
    return false
  end
end

# Run validation
if __FILE__ == $0
  config_file = ARGV[0] || 'config/ai_models_config.yml'
  valid = validate_ai_models_config(config_file)
  exit(valid ? 0 : 1)
end
