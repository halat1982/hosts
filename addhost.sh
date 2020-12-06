#!/bin/bash
if [[ $1 == "" ]]; then	
	echo 'Need domain name. Input it like ./addhost.sh domain.name';
	exit;
fi

echo "Create folder struct"
mkdir -p /var/www/$1 && \
cat > /etc/apache2/sites-available/$1.conf <<EOF 
<VirtualHost *:80>
    ServerName $1
    ServerAlias www.$1
    ServerAdmin halat@tut.by
    DocumentRoot /var/www/$1
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
sudo a2ensite $1 && \
sudo systemctl reload apache2 && \
echo "127.0.0.1  $1" >> /etc/hosts
cd /var/www/$1 

if [[ $2 == 'restore' ]]; then	
	wget http://www.1c-bitrix.ru/download/scripts/restore.php
fi	

git init && \
git config core.filemode false && \
sudo chown -R www-data:www-data /var/www/$1/
