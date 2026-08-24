#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

# Update packages
apt-get update -y
apt-get upgrade -y

# Install required packages
apt-get install -y \
  git \
  curl \
  mysql-client

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install Corepack / Yarn
npm install -g corepack
corepack enable
corepack prepare yarn@stable --activate

# Install PM2
npm install -g pm2

# Clone backend repository
cd /home/ubuntu

if [ ! -d "/home/ubuntu/aws_three_tier_project" ]; then
    git clone https://github.com/Ramani-github/aws_three_tier_project.git
fi

cd /home/ubuntu/aws_three_tier_project/backend

# Create .env file
cat > .env <<EOF
DB_HOST=${db_host}
DB_USERNAME=${db_username}
DB_PASSWORD=${db_password}
DB_NAME=${db_name}
PORT=${backend_port}
EOF

# Install dependencies
npm install

# Make sure dotenv is installed
npm install dotenv

# Change ownership
chown -R ubuntu:ubuntu /home/ubuntu/aws_three_tier_project

# Start backend using PM2
su - ubuntu -c "
  cd /home/ubuntu/aws_three_tier_project/backend
  pm2 start index.js --name backendApi
  pm2 save
"

# Configure PM2 to start after reboot
env PATH=$PATH:/usr/bin pm2 startup systemd \
    -u ubuntu \
    --hp /home/ubuntu || true

systemctl daemon-reload

echo "Backend installation completed."
