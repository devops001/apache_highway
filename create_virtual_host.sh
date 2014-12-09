#!/usr/bin/env bash

SITES_DIR=/etc/apache2/sites-available

VHOST_NAME="apache_highway"

######################################################
# create the public docroot folder if it doesn't exist:
######################################################

if [[ ! -d /var/www/$VHOST_NAME ]]; then
  mkdir /var/www/$VHOST_NAME
fi

######################################################
# create a virtual host config file:
######################################################

read -r -d '' VHOST_CONF <<EOCONF
<VirtualHost *:80>
  ServerAdmin  $(whoami)@localhost
  ServerName   $VHOST_NAME
  ServerAlias  $VHOST_NAME
  DocumentRoot /var/www/$VHOST_NAME
  ErrorLog     ${APACHE_LOG_DIR}/error.log
  CustomLog    ${APACHE_LOG_DIR}/access.log combined

  # allow ruby & perl scripts to be executed from this sites root path:
  <Directory "/var/www/$VHOST_NAME">
    Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
    AddHandler cgi-script .rb .pl
  </Directory>

  # alow CORS requests from http://localhost and http://otherdomain, but block all other domains:
  <IfModule mod_headers.c>
    SetEnvIf Origin "^(http:\/\/localhost|http:\/\/otherdomain)$" ORIGIN_SUB_DOMAIN=$1
    Header set Access-Control-Allow-Origin "%{ORIGIN_SUB_DOMAIN}e"
  </IfModule>
</VirtualHost>
EOCONF

sudo echo "$VHOST_CONF" > $SITES_DIR/${VHOST_NAME}.conf

######################################################
# add the new site to the /etc/hosts file:
######################################################

HOSTS_ENTRY="127.0.0.1 $VHOST_NAME"
EXISTS=$(grep -c "^$HOSTS_ENTRY" /etc/hosts)
if [[ $EXISTS > 0 ]]; then
  echo "There is already an entry for this vhost in /etc/hosts:"
else
  echo "Adding entry to /etc/hosts: $HOSTS_ENTRY"
  sudo echo "$HOSTS_ENTRY" >> /etc/hosts
fi

######################################################
# enable the new site and reload apache2:
######################################################

sudo a2ensite $VHOST_NAME
sudo service apache2 reload

echo "try it out:  http://$VHOST_NAME"

