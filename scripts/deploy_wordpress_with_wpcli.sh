#!/bin/bash

#Esto muestra todos los comandos que se van ejecutando
set -ex 
#Actualizamos los repositorios
apt update

#Actualizamos los paquetes de la máquina 

#apt upgrade -y

#Incluimos las variables del archivo .env

source .env

#Eliminamos instalaciones previas 

rm -rf /tmp/wp-cli.phar

# Descargamos la utilidad de wp-cli

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

#Le asignamos permisos de ejecución al archivo wp-cli.phar

chmod +x /tmp/wp-cli.phar

#Movemos el archivo al directorio /usr/local/bin que almacena el listado de comandos del sistema.

mv /tmp/wp-cli.phar /usr/local/bin/wp #wp es renombrado


#Eliminamos instalaciones previas de wordpress

rm -rf /var/www/html/*

#Descargamos el codigo fuente de wordpress en /var/wwW/html

wp core download --locale=es_ES --path=/var/www/html --allow-root


# Creamos la base de datos y el usuario de base de datos.

mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

#Crear el archivo .config, podemos comprobar haciendo un cat cat /var/www/html/wp-config.php si estan bien las variables

wp config create \
  --dbname=wordpress \
  --dbuser=wp_user \
  --dbpass=wp_pass \
  --path=/var/www/html \
  --allow-root


#Instalamos el directorio WORDPRESS con las variables de configuración en .env

wp core install \
  --url=$CERTIFICATE_DOMAIN \
  --title="$WORDPRESS_TITLE"\
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASS \
  --admin_email=$WORDPRESS_ADMIN_EMAIL \
  --path=/var/www/html \
  --allow-root

#Copiamos el archivo .htaccess

cp ../htaccess/.htaccess /var/www/html/

# Descargamos un plugin para la seguridad de WordPress

sudo wp plugin install wp-staging --activate --path=/var/www/html --allow-root

#Descargamos un tema cualquiera para la configuración

sudo wp  theme install Hestia --activate list --path=/var/www/html --allow-root

#Descargamos un pluggin cualquiera.

sudo wp plugin install bbpress --activate --path=/var/www/html --allow-root
#Modificamos los permisos de /var/www/html

chown -R www-data:www-data /var/www/html