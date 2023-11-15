#!/bin/bash

#Esto muestra todos los comandos que se van ejecutando
set -x 
#Actualizamos los repositorios
apt update

#Añadimos el source

source .env

#Actualizamos los paquetes de la máquina 

#apt upgrade -y

# Instalamos Mysql L.

sudo apt install mysql-server -y

#Configuramos MYSQL para que sólo acepte conexiones desde la IP privada

sed -i "s/127.0.0.1/$MYSQL_PRIVATE_IP/" /etc/mysql/mysql.conf.d/mysqld.cnf


#Creamos el usuario en MYSQL

DROP USER IF EXISTS '$DB_USER'@'$FRONTEND_PRIVATE_IP';
CREATE USER '$DB_USER'@'$FRONTEND_PRIVATE_IP' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON '$DB_NAME'.* TO '$DB_USER'@'$FRONTEND_PRIVATE_IP';

#Reiniciamos el servicio de mysql

systemctl restart mysql