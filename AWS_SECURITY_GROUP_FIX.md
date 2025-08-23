# 🔥 AWS SECURITY GROUP CONFIGURATION FOR CLOUDFLARE
# ================================================

## 🚨 IMMEDIATE ACTION REQUIRED

Your **onelastai.com** is showing **Error 522** because Cloudflare cannot reach your EC2 server.
The issue is that **Cloudflare IP ranges are not allowed** in your AWS Security Group.

## 📋 STEP-BY-STEP FIX

### 1. Open AWS Console
- Go to **AWS Console** → **EC2** → **Security Groups**
- Find the security group attached to instance `122.248.242.170`

### 2. Edit Inbound Rules
Click **"Edit inbound rules"** and add these entries:

#### For HTTP (Port 80):
```
Type: Custom TCP
Port Range: 80
Source: Custom
CIDR blocks (add each as separate rule):
173.245.48.0/20
103.21.244.0/22
103.22.200.0/22
103.31.4.0/22
141.101.64.0/18
108.162.192.0/18
190.93.240.0/20
188.114.96.0/20
197.234.240.0/22
198.41.128.0/17
162.158.0.0/15
104.16.0.0/13
104.24.0.0/14
172.64.0.0/13
131.0.72.0/22
```

#### For HTTPS (Port 443):
```
Type: Custom TCP
Port Range: 443
Source: Custom
CIDR blocks: (Same as above - add each as separate rule)
```

#### For Rails Backup (Port 3000):
```
Type: Custom TCP
Port Range: 3000
Source: Custom
CIDR blocks: (Same as above - add each as separate rule)
```

### 3. Quick Test (Temporary)
For immediate testing, you can temporarily add:
```
Type: HTTP
Port Range: 80
Source: Anywhere (0.0.0.0/0)

Type: HTTPS
Port Range: 443
Source: Anywhere (0.0.0.0/0)
```

## 🔍 CURRENT STATUS CHECK

### SSL Certificates:
- **Status**: Need to verify installation
- **Domain**: onelastai.com, www.onelastai.com
- **Location**: /etc/letsencrypt/live/onelastai.com/

### Nginx Configuration:
- **Config File**: /etc/nginx/sites-available/onelastai
- **Status**: Active and configured for SSL

### Rails Application:
- **Status**: Running on port 3000
- **Mode**: Production
- **Process Manager**: PM2

## 🎯 EXPECTED RESULT

After adding Cloudflare IP ranges:
- ✅ **https://onelastai.com** - Working with SSL
- ✅ **http://onelastai.com** - Redirects to HTTPS
- ✅ **http://122.248.242.170** - Direct access works

## 🚨 PRIORITY ORDER

1. **FIRST**: Add Cloudflare IPs to Security Group (fixes Error 522)
2. **SECOND**: Verify SSL certificates are installed
3. **THIRD**: Test domain access

**The Security Group fix will resolve the Error 522 immediately!**
