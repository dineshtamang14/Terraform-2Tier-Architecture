#!/bin/bash

sudo su
yum update -y
amazon-linux-extras install epel -y
yum install nginx -y
cd /usr/share/nginx/html
rm index.html poweredby.png nginx-logo.png
cd ..
aws s3 cp s3://bigprodcompany-builds/application-prod.zip application-prod.zip
unzip application-prod.zip
mv 2131_wedding_lite/* html
rm -rf 2131_wedding_lite
rm application-prod.zip
systemctl start nginx
systemctl enable nginx
