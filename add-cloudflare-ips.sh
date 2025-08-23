#!/bin/bash

# Get Cloudflare IP ranges
echo "🔍 Getting Cloudflare IP ranges..."

# Cloudflare IPv4 ranges
CLOUDFLARE_IPS=(
    "173.245.48.0/20"
    "103.21.244.0/22"
    "103.22.200.0/22"
    "103.31.4.0/22"
    "141.101.64.0/18"
    "108.162.192.0/18"
    "190.93.240.0/20"
    "188.114.96.0/20"
    "197.234.240.0/22"
    "198.41.128.0/17"
    "162.158.0.0/15"
    "104.16.0.0/13"
    "104.24.0.0/14"
    "172.64.0.0/13"
    "131.0.72.0/22"
)

# Get the security group ID (replace with your actual security group ID)
SECURITY_GROUP_ID="sg-xxxxxxxxx"  # YOU NEED TO UPDATE THIS
REGION="ap-southeast-1"

echo "🛡️ Adding Cloudflare IP ranges to Security Group: $SECURITY_GROUP_ID"

# Add HTTP (port 80) rules for Cloudflare IPs
for ip in "${CLOUDFLARE_IPS[@]}"; do
    echo "Adding HTTP rule for $ip"
    aws ec2 authorize-security-group-ingress \
        --group-id $SECURITY_GROUP_ID \
        --protocol tcp \
        --port 80 \
        --cidr $ip \
        --region $REGION
done

# Add HTTPS (port 443) rules for Cloudflare IPs
for ip in "${CLOUDFLARE_IPS[@]}"; do
    echo "Adding HTTPS rule for $ip"
    aws ec2 authorize-security-group-ingress \
        --group-id $SECURITY_GROUP_ID \
        --protocol tcp \
        --port 443 \
        --cidr $ip \
        --region $REGION
done

echo "✅ Cloudflare IP ranges added to Security Group!"
echo "🔍 Current Security Group rules:"
aws ec2 describe-security-groups --group-ids $SECURITY_GROUP_ID --region $REGION --query 'SecurityGroups[0].IpPermissions'
