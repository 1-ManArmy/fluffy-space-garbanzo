#!/bin/bash

echo "🔥 FETCHING CURRENT CLOUDFLARE IP RANGES..."
echo "=========================================="

# Get Cloudflare IPs
response=$(curl -s https://api.cloudflare.com/client/v4/ips)

echo "📡 RAW API RESPONSE:"
echo "$response"
echo ""

# Extract IPv4 ranges
echo "🌐 IPv4 CIDR RANGES (for AWS Security Group):"
echo "$response" | grep -o '"ipv4_cidrs":\[[^]]*\]' | sed 's/"ipv4_cidrs":\[//; s/\]//; s/","/\n/g; s/"//g'
echo ""

# Extract IPv6 ranges  
echo "🌍 IPv6 CIDR RANGES (for AWS Security Group):"
echo "$response" | grep -o '"ipv6_cidrs":\[[^]]*\]' | sed 's/"ipv6_cidrs":\[//; s/\]//; s/","/\n/g; s/"//g'
echo ""

echo "🚨 INSTRUCTIONS FOR AWS CONSOLE:"
echo "================================="
echo "1. Go to AWS Console > EC2 > Security Groups"
echo "2. Find your EC2 instance security group"
echo "3. Edit Inbound Rules"
echo "4. Add CUSTOM TCP rules for:"
echo "   - Port 80 (HTTP)"
echo "   - Port 443 (HTTPS)"  
echo "   - Port 3000 (Rails backup)"
echo "5. Use the IPv4 CIDR ranges listed above"
echo ""

# Also get traditional Cloudflare IP ranges as backup
echo "📋 BACKUP - WELL-KNOWN CLOUDFLARE IPv4 RANGES:"
echo "173.245.48.0/20"
echo "103.21.244.0/22"
echo "103.22.200.0/22"
echo "103.31.4.0/22"
echo "141.101.64.0/18"
echo "108.162.192.0/18"
echo "190.93.240.0/20"
echo "188.114.96.0/20"
echo "197.234.240.0/22"
echo "198.41.128.0/17"
echo "162.158.0.0/15"
echo "104.16.0.0/13"
echo "104.24.0.0/14"
echo "172.64.0.0/13"
echo "131.0.72.0/22"
