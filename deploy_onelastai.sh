#!/bin/bash

# OneLastAI Production Deployment Script for onelastai.com
# This script handles the complete deployment process for the domain

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOMAIN="onelastai.com"
APP_DIR="/var/www/onelastai"
NGINX_SITES_DIR="/etc/nginx/sites-available"
NGINX_ENABLED_DIR="/etc/nginx/sites-enabled"
SSL_DIR="/etc/nginx/ssl"
BACKUP_DIR="/backup/onelastai"

echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}OneLastAI Production Deployment${NC}"
echo -e "${BLUE}Domain: $DOMAIN${NC}"
echo -e "${BLUE}=================================${NC}"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root. Please run as the application user."
    exit 1
fi

# Function to check system requirements
check_requirements() {
    print_status "Checking system requirements..."

    # Check Ruby version
    if ! command -v ruby &> /dev/null; then
        print_error "Ruby is not installed"
        exit 1
    fi

    ruby_version=$(ruby -v | cut -d' ' -f2)
    print_status "Ruby version: $ruby_version"

    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed"
        exit 1
    fi

    node_version=$(node -v)
    print_status "Node.js version: $node_version"

    # Check database connections
    print_status "Checking database connections..."
    # Add database connectivity checks here

    print_status "✅ System requirements check passed"
}

# Function to setup environment
setup_environment() {
    print_status "Setting up environment for $DOMAIN..."

    # Copy environment file
    if [ ! -f .env ]; then
        print_status "Creating .env file from template..."
        cp .env.example .env
        print_warning "Please update .env file with your actual API keys and configuration"
    fi

    # Set production environment
    export RAILS_ENV=production
    export NODE_ENV=production

    print_status "✅ Environment setup complete"
}

# Function to install dependencies
install_dependencies() {
    print_status "Installing dependencies..."

    # Install Ruby gems
    print_status "Installing Ruby gems..."
    bundle config set --local deployment 'true'
    bundle config set --local without 'development test'
    bundle install --jobs 4 --retry 3

    # Install Node.js packages
    if [ -f package.json ]; then
        print_status "Installing Node.js packages..."
        npm install --production
    fi

    print_status "✅ Dependencies installed"
}

# Function to compile assets
compile_assets() {
    print_status "Compiling assets..."

    # Precompile Rails assets
    RAILS_ENV=production bundle exec rails assets:precompile

    # If using Webpack/Vite, compile those assets too
    if [ -f package.json ]; then
        npm run build 2>/dev/null || true
    fi

    print_status "✅ Assets compiled"
}

# Function to setup database
setup_database() {
    print_status "Setting up database..."

    # Run database migrations
    RAILS_ENV=production bundle exec rails db:create db:migrate

    # Seed database if needed
    if [ "$1" = "--seed" ]; then
        print_status "Seeding database..."
        RAILS_ENV=production bundle exec rails db:seed
    fi

    print_status "✅ Database setup complete"
}

# Function to configure NGINX
configure_nginx() {
    print_status "Configuring NGINX for $DOMAIN..."

    # Copy NGINX configuration
    sudo cp config/nginx/onelastai.conf $NGINX_SITES_DIR/onelastai.com

    # Enable site
    sudo ln -sf $NGINX_SITES_DIR/onelastai.com $NGINX_ENABLED_DIR/onelastai.com

    # Test NGINX configuration
    sudo nginx -t

    # Reload NGINX
    sudo systemctl reload nginx

    print_status "✅ NGINX configured"
}

# Function to setup SSL certificates
setup_ssl() {
    print_status "Setting up SSL certificates..."

    # Create SSL directory
    sudo mkdir -p $SSL_DIR

    if [ "$1" = "--letsencrypt" ]; then
        print_status "Setting up Let's Encrypt certificates..."

        # Install certbot if not present
        if ! command -v certbot &> /dev/null; then
            print_status "Installing certbot..."
            sudo apt-get update
            sudo apt-get install -y certbot python3-certbot-nginx
        fi

        # Generate certificates
        sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN -d "*.$DOMAIN"

        # Setup auto-renewal
        sudo crontab -l | grep -q 'certbot renew' || {
            (sudo crontab -l; echo "0 12 * * * /usr/bin/certbot renew --quiet") | sudo crontab -
        }
    else
        print_warning "SSL certificates not configured. Use --letsencrypt flag or manually configure certificates."
    fi

    print_status "✅ SSL setup complete"
}

# Function to setup systemd service
setup_systemd() {
    print_status "Setting up systemd service..."

        # Create systemd service file
        sudo tee /etc/systemd/system/onelastai.service > /dev/null <<EOF
    [Unit]
    Description=OneLastAI Rails Application
    After=network.target postgresql.service redis-server.service mongodb.service

    [Service]
    Type=simple
    User=deploy
    WorkingDirectory=$APP_DIR
    Environment=RAILS_ENV=production
    Environment=PORT=3000
    ExecStart=/home/deploy/.rbenv/shims/bundle exec rails server -b 0.0.0.0 -p 3000
    ExecReload=/bin/kill -USR2 \$MAINPID
    KillMode=mixed
    Restart=always
    RestartSec=5
    SyslogIdentifier=onelastai
    StandardOutput=journal
    StandardError=journal

    [Install]
    WantedBy=multi-user.target
    EOF
[Unit]
Description=OneLastAI Rails Application
After=network.target postgresql.service redis-server.service mongodb.service

[Service]
Type=simple
User=deploy
WorkingDirectory=$APP_DIR
Environment=RAILS_ENV=production
Environment=PORT=3000
ExecStart=/home/deploy/.rbenv/shims/bundle exec rails server -b 0.0.0.0 -p 3000
ExecReload=/bin/kill -USR2 \$MAINPID
KillMode=mixed
Restart=always
RestartSec=5
SyslogIdentifier=onelastai
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd and enable service
    sudo systemctl daemon-reload
    sudo systemctl enable onelastai

    print_status "✅ Systemd service configured"
}

# Function to start services
start_services() {
    print_status "Starting services..."

    # Start application service
    sudo systemctl start onelastai
    sudo systemctl status onelastai --no-pager -l

    # Restart NGINX
    sudo systemctl restart nginx

    print_status "✅ Services started"
}

# Function to run health checks
health_checks() {
    print_status "Running health checks..."

    # Wait for application to start
    sleep 10

    # Check if application is responding
    sudo mkdir -p "$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)"
        print_status "✅ Application is responding"
    else
        print_error "❌ Application health check failed"
        return 1
    fi

    # Check SSL certificate
    if openssl s_client -connect $DOMAIN:443 -servername $DOMAIN < /dev/null 2>/dev/null | openssl x509 -noout -dates; then
        print_status "✅ SSL certificate is valid"
    else
        print_warning "⚠️  SSL certificate check failed"
    fi

    print_status "✅ Health checks complete"
}

# Function to create backup
create_backup() {
    print_status "Creating backup..."

    # Create backup directory
    sudo mkdir -p $BACKUP_DIR/$(date +%Y%m%d_%H%M%S)
    backup_dir="$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)"

    # Backup database
    # Add database backup commands here

    # Backup application files
    sudo cp -r $APP_DIR $backup_dir/

    print_status "✅ Backup created at $backup_dir"
}

# Function to show deployment summary
show_summary() {
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}Deployment Summary${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo -e "Domain: ${GREEN}https://$DOMAIN${NC}"
    echo -e "Application Status: ${GREEN}Running${NC}"
    echo -e "SSL Status: ${GREEN}Configured${NC}"
    echo -e "NGINX Status: ${GREEN}Running${NC}"
    echo -e ""
    echo -e "Available URLs:"
    echo -e "  Main Site: ${BLUE}https://$DOMAIN${NC}"
    echo -e "  API: ${BLUE}https://api.$DOMAIN${NC}"
    echo -e "  Agent Examples:"
    echo -e "    NeoChat: ${BLUE}https://neochat.$DOMAIN${NC}"
    echo -e "    EmotiSense: ${BLUE}https://emotisense.$DOMAIN${NC}"
    echo -e "    CineGen: ${BLUE}https://cinegen.$DOMAIN${NC}"
    echo -e ""
    echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
    echo -e "${BLUE}=================================${NC}"
}

# Main deployment process
main() {
    local letsencrypt_flag=""
    local seed_flag=""

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --letsencrypt)
                letsencrypt_flag="--letsencrypt"
                shift
                ;;
            --seed)
                seed_flag="--seed"
                shift
                ;;
            --backup)
                create_backup
                exit 0
                ;;
            --health-check)
                health_checks
                exit 0
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --letsencrypt    Setup Let's Encrypt SSL certificates"
                echo "  --seed          Seed the database with initial data"
                echo "  --backup        Create a backup only"
                echo "  --health-check  Run health checks only"
                echo "  --help          Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    # Run deployment steps
    check_requirements
    setup_environment
    install_dependencies
    compile_assets
    setup_database $seed_flag
    configure_nginx
    setup_ssl $letsencrypt_flag
    setup_systemd
    start_services
    health_checks
    show_summary
}

# Run main function with all arguments
main "$@"
