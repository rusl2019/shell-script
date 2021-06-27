#!/usr/bin/env bash

dnf install -y epel-release yum-utils unzip curl wget \
bash-completion policycoreutils-python-utils mlocate bzip2

dnf update -y

# Apache

dnf install -y httpd

systemctl enable httpd.service
systemctl start httpd.service

# PHP

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm

dnf install yum-utils

dnf module reset php
dnf module install php:remi-7.4
dnf update

# Installing PHP and the required modules

dnf install -y php php-gd php-mbstring php-intl php-pecl-apcu\
     php-mysqlnd php-opcache php-json php-zip

# Installing optional modules redis/imagick

dnf install -y php-redis php-imagick

# Database

dnf install -y mariadb mariadb-server

systemctl enable mariadb.service
systemctl start mariadb.service

mysql_secure_installation

# Create database
# mysql -u root -p

# MariaDB [(none)]> CREATE DATABASE nextcloud;
# MariaDB [(none)]> CREATE USER `admin`@`localhost` IDENTIFIED BY 'pass';
# MariaDB [(none)]> GRANT ALL ON nextcloud.* TO `admin`@`localhost`;
# MariaDB [(none)]> FLUSH PRIVILEGES;
# MariaDB [(none)]> exit

# Redis

dnf install -y redis
systemctl enable redis.service
systemctl start redis.service

# Installing Nextcloud

wget https://download.nextcloud.com/server/releases/nextcloud-21.0.2.zip
unzip nextcloud-*.zip

cp -R nextcloud/ /var/www/html/
mkdir /var/www/html/nextcloud/data
chown -R apache:apache /var/www/html/nextcloud

systemctl restart httpd.service

firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --reload

firewall-cmd --add-port=80/tcp --zone=public --permanent
firewall-cmd --reload

# SELinux

semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/data'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/config(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/apps(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/.htaccess'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/.user.ini'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/3rdparty/aws/aws-sdk-php/src/data/logs(/.*)?'
restorecon -Rv '/var/www/html/nextcloud/'

setsebool -P httpd_can_network_connect on
