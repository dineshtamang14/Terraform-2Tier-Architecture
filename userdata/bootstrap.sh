#!/bin/bash

# Get input values
read -p "Enter RDS endpoint: " db_endpoint
read -p "Enter RDS database name: " db_name
read -p "Enter RDS username: " db_username
read -s -p "Enter RDS password: " db_password

# Install and configure WordPress
sudo su
apt update && apt upgrade -y
apt install nginx php-fpm php-mysql php-curl php-dom php-mbstring php-imagick php-zip php-gd wget -y

cat > /etc/nginx/sites-available/wordpress.conf <<EOF
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/wordpress;

	# Add index.php to the list if you are using PHP
	index index.php;

	server_name _;

	location / {
		try_files $uri $uri/ =404;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
	
		# With php-fpm (or other unix sockets):
		fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
		# With php-cgi (or other tcp sockets):
		# fastcgi_pass 127.0.0.1:9000;
	}
}
EOF

ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
cd /var/www
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo rm latest.tar.gz

cat > /var/www/wordpress/wp-config.php <<EOF
<?php
define( 'DB_NAME', '${db_name}' );
define( 'DB_USER', '${db_username}' );
define( 'DB_PASSWORD', '${db_password}' );
define( 'DB_HOST', '${db_endpoint}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', 'utf8_unicode_ci );
EOF

rm wordpress/wp-config-sample.php
chown -R www-data:www-data wordpress
find wordpress/ -type d -exec chmod 755 {} \;
find wordpress/ -type f -exec chmod 644 {} \;
systemctl restart nginx
