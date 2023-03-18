#!/bin/bash

# Get input values
read -p "Enter RDS endpoint: " db_endpoint
read -p "Enter RDS database name: " db_name
read -p "Enter RDS username: " db_username
read -s -p "Enter RDS password: " db_password

# Install and configure WordPress
sudo su
apt update && apt upgrade -y
apt install nginx php-fpm php-mysql php-curl php-dom php-mbstring php-imagick php-zip php-gd wget unzip -y
apt install php-imagick php7.4-fpm php7.4-mbstring php7.4-bcmath php7.4-xml php7.4-mysql php7.4-common php7.4-gd php7.4-json php7.4-cli php7.4-curl php7.4-zip -y
mkdir -p /usr/share/nginx

cat > /etc/nginx/conf.d/wordpress.conf <<EOF
server {
  listen 80;
  listen [::]:80;
  server_name _;
  root /usr/share/nginx/wordpress;
  index index.php index.html index.htm index.nginx-debian.html;

  location / {
    try_files $uri $uri/ /index.php;
  }

   location ~ ^/wp-json/ {
     rewrite ^/wp-json/(.*?)$ /?rest_route=/$1 last;
   }

  location ~* /wp-sitemap.*\.xml {
    try_files $uri $uri/ /index.php$is_args$args;
  }
  client_max_body_size 20M;

  location ~ \.php$ {
    fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    include snippets/fastcgi-php.conf;
    fastcgi_buffers 1024 4k;
    fastcgi_buffer_size 128k;

    # Add headers to serve security related headers
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Permitted-Cross-Domain-Policies none;
    add_header X-Frame-Options "SAMEORIGIN";
  }

  #enable gzip compression
  gzip on;
  gzip_vary on;
  gzip_min_length 1000;
  gzip_comp_level 5;
  gzip_types application/json text/css application/x-javascript application/javascript image/svg+xml;
  gzip_proxied any;

  # A long browser cache lifetime can speed up repeat visits to your page
  location ~* \.(jpg|jpeg|gif|png|webp|svg|woff|woff2|ttf|css|js|ico|xml)$ {
       access_log        off;
       log_not_found     off;
       expires           360d;
  }

  # disable access to hidden files
  location ~ /\.ht {
      access_log off;
      log_not_found off;
      deny all;
  }

}
EOF

wget https://wordpress.org/latest.zip
unzip latest.zip -d /usr/share/nginx/
sudo rm latest.zip

cat > /usr/share/nginx/wordpress/wp-config.php <<EOF
<?php
define( 'DB_NAME', '${db_name}' );
define( 'DB_USER', '${db_username}' );
define( 'DB_PASSWORD', '${db_password}' );
define( 'DB_HOST', '${db_endpoint}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', 'utf8_unicode_ci );
EOF

rm /usr/share/nginx/wordpress/wp-config-sample.php
chown www-data:www-data /usr/share/nginx/wordpress/ -R
nginx -t
systemctl reload nginx
systemctl reload php7.4-fpm