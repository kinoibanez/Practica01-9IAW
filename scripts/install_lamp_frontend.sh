#!/bin/bash

#Esto muestra todos los comandos que se van ejecutando
set -x 
#Actualizamos los repositorios
apt update

#Actualizamos los paquetes de la máquina 

#apt upgrade -y

# Instalamos el servidor web apache A.

apt install apache2 -y

# Instalamos PHP.

sudo apt install php libapache2-mod-php php-mysql -y

#Copiamos el directorio 000-default.conf (Archivo de configuración de apache2)

cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

# Instalamos PHP.

sudo apt install php libapache2-mod-php php-mysql -y

# Reiniciamos el servicio (apache)

systemctl restart  apache2

# Modificamos el propietario y el grupo del directorio /var/www/html

chown -R www-data:www-data /var/www/html



