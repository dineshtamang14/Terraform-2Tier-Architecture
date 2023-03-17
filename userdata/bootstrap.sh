#!/bin/bash

# Get input values
read -p "Enter RDS endpoint: " db_endpoint
read -p "Enter RDS database name: " db_name
read -p "Enter RDS username: " db_username
read -s -p "Enter RDS password: " db_password

# Install and configure WordPress
sudo su
apt update && apt upgrade -y
apt install apache2 php libapache2-mod-php php-mysql -y
rm -rf /var/www/html/*

cat > /var/www/html/wp-config.php <<EOF
<?php
define( 'DB_NAME', '${db_name}' );
define( 'DB_USER', '${db_username}' );
define( 'DB_PASSWORD', '${db_password}' );
define( 'DB_HOST', '${db_endpoint}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', 'utf8_general_ci' );
EOF

curl -O https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz -C /var/www/html --strip-components=1
rm /var/www/html/latest.tar.gz
cd /var/www/html
chown -R www-data: .