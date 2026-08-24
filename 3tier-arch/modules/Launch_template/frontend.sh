#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

# Update packages
apt-get update -y
apt-get upgrade -y

# Install required packages
apt-get install -y \
  apache2 \
  git \
  curl \
  unzip

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install Corepack / Yarn
npm install -g corepack
corepack enable
corepack prepare yarn@stable --activate

# Install PM2
npm install -g pm2

# Enable Apache
systemctl enable apache2
systemctl start apache2

# Switch to ubuntu user's home
cd /home/ubuntu

# Clone application
if [ ! -d "/home/ubuntu/aws_three_tier_project" ]; then
    git clone https://github.com/Ramani-github/aws_three_tier_project.git
fi

cd /home/ubuntu/aws_three_tier_project/clients

# Configure API endpoint
cat > src/pages/config.js <<'EOF'
const config = {
  apiUrl: "http://${backend_domain}:"
};

export default config;
EOF

# Install frontend dependencies
npm install

# Build frontend
npm run build

# Deploy frontend to Apache
rm -rf /var/www/html/*
cp -r build/* /var/www/html/

# Set permissions
chown -R www-data:www-data /var/www/html

# Restart Apache
systemctl restart apache2

# Configure PM2 startup for ubuntu user
su - ubuntu -c "pm2 startup systemd -u ubuntu --hp /home/ubuntu" || true

echo "Frontend installation completed."
