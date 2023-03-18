#!/bin/bash

# Get input values
read -p "Enter RDS endpoint: " db_endpoint
read -p "Enter RDS database name: " db_name
read -p "Enter RDS username: " db_username
read -s -p "Enter RDS password: " db_password

# Install and configure WordPress
sudo su
apt update && apt upgrade -y
apt install nginx php-fpm php-mysql php-curl php-dom php-mbstring php-imagick php-zip php-gd -y
rm -rf /var/www/html/*

cat > /var/www/html/wp-config.php <<EOF
<?php
define( 'DB_NAME', '${db_name}' );
define( 'DB_USER', '${db_username}' );
define( 'DB_PASSWORD', '${db_password}' );
define( 'DB_HOST', '${db_endpoint}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', 'utf8_unicode_ci );
EOF

cat > /etc/nginx/sites-available/default <<EOF
upstream php-handler {
        server unix:/var/run/php/php7.4-fpm.sock;
}
server {
        listen 80;
        server_name _;
        root /var/www/html;
        index index.php;
        location / {
                try_files $uri $uri/ /index.php?$args;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass php-handler;
        }
}
EOF

curl -O https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz -C /var/www/html --strip-components=1
rm /var/www/html/latest.tar.gz
cd /var/www
chown -R www-data:www-data html
find html/ -type d -exec chmod 755 {} \;
find html/ -type f -exec chmod 644 {} \;
systemctl enable nginx
systemctl restart nginx