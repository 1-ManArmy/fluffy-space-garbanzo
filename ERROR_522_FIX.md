# 🚨 ERROR 522 RESOLUTION CHECKLIST

## ISSUE: Cloudflare Error 522 - Connection timed out

### ROOT CAUSE:
1. ❌ Cloudflare IPs are blocked by AWS Security Group
2. ❌ SSL certificates may not be properly installed
3. ❌ Nginx might not be running correctly

### IMMEDIATE FIXES NEEDED:

## 1. AWS SECURITY GROUP (CRITICAL)
**Go to AWS Console NOW and add these inbound rules:**

**For HTTP (Port 80):**
- Source: 173.245.48.0/20
- Source: 103.21.244.0/22
- Source: 103.22.200.0/22
- Source: 103.31.4.0/22
- Source: 141.101.64.0/18
- Source: 108.162.192.0/18
- Source: 190.93.240.0/20
- Source: 188.114.96.0/20
- Source: 197.234.240.0/22
- Source: 198.41.128.0/17
- Source: 162.158.0.0/15
- Source: 104.16.0.0/13
- Source: 104.24.0.0/14
- Source: 172.64.0.0/13
- Source: 131.0.72.0/22

**For HTTPS (Port 443):** Same IP ranges as above

## 2. QUICK TEST (TEMPORARY):
Add these open rules for testing:
- HTTP (80): 0.0.0.0/0
- HTTPS (443): 0.0.0.0/0

## 3. SSL CERTIFICATE STATUS:
- Need to verify if certificates are installed
- May need to run certbot again
- Check if Nginx is configured for SSL

## 4. CLOUDFLARE SETTINGS:
- Ensure SSL/TLS is set to "Full" or "Full (strict)"
- Check if origin server is set correctly

### NEXT STEPS:
1. Update Security Group FIRST
2. Test https://onelastai.com again
3. Install SSL certificates if needed
4. Configure Cloudflare properly
