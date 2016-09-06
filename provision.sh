#!/bin/bash

# Arguments
MYSQL_PASSWORD=${1}
SERVER_NAME=${2}
SERVER_ALIAS=${3}
SERVER_ADMIN=${4}

# Basics
apt-get -y -q update
apt-get -y -q upgrade

## Install packages
### Supresses password prompt
echo mysql-server-5.5 mysql-server/root_password password $MYSQL_PASSWORD | debconf-set-selections
echo mysql-server-5.5 mysql-server/root_password_again password $MYSQL_PASSWORD | debconf-set-selections
apt-get -y -q install git mysql-server apache2 php5 php5-cli php5-mysql

# Setup webserver
echo '<VirtualHost *:80>
  # General
  ServerName '$SERVER_NAME'
  ServerAlias www.'$SERVER_NAME'
	ServerAlias '$SERVER_ALIAS'
	ServerAlias www.'$SERVER_ALIAS'
  ServerAdmin '$SERVER_ADMIN'

  # Site
  DocumentRoot /var/www
  <Directory "/var/www">
    Require all granted
  </Directory>

  # Logs
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
' > /etc/apache2/sites-available/000-default.conf

a2enmod rewrite
a2dissite default-ssl

sed -i 's/^\(;\)\(date\.timezone\s*=\).*$/\2 \"Europe\/Berlin\"/' /etc/php5/apache2/php.ini

# Clean up virtual hosts
rm /etc/apache2/sites-available/default-ssl.conf

service apache2 restart

# Setup database
sed -i 's/^\(max_allowed_packet\s*=\s*\).*$/\1128M/' /etc/mysql/my.cnf

echo '[client]
user = root
password = '$MYSQL_PASSWORD'

[mysqladmin]
user = root
password = '$MYSQL_PASSWORD > /home/vagrant/.my.cnf

service mysql restart
