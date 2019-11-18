#!/bin/bash
curl -fsSL https://get.docker.com | sh
DB_HOST="mysql"
DB_USER="root"
DB_PASS="admin"
AB_PORT="80"
AB2_PORT="8999"
AB_LOGIN="admin"
AB_PASS="palman00$$"

if ! [ -d ./www ]; then
mkdir ./www
fi

if ! [ -d ./mysql ]; then
mkdir ./mysql
fi

docker-compose up -d --build

if ! [ -d ./www/abantecart ]; then
sleep 60;
docker-compose exec abantecart-dev mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -e "create database abantecart;";

git clone https://github.com/abantecart/abantecart-src.git ./www/abantecart
docker-compose exec abantecart-dev chown -R www-data:www-data /var/www/abantecart
docker-compose exec abantecart-dev /usr/local/bin/php /var/www/abantecart/public_html/install/cli_install.php install --db_host=$DB_HOST --db_user=$DB_USER --db_password=$DB_PASS --db_name=abantecart  --db_driver=amysqli  --db_prefix=abc_ --admin_path=admin  --username=$AB_LOGIN  --password=$AB_PASS  --email=admin@admin.com  --http_server=http://localhost:$AB_PORT/ --with-sample-data
fi

