#!/bin/bash

#Esto muestra todos los comandos que se van ejecutando
set -ex 
#Actualizamos los repositorios
apt update

#Actualizamos los paquetes de la máquina 

#apt upgrade -y

#Importamos el archivo de variables .env

source .env

#Instalamos y Actualizamos snapd.

snap install core
snap refresh core

# Eliminamos cualquier instalación previa de certobot con apt.

apt remove certbot

# Instalamos el cliente de Certbot con snapd.

snap install --classic certbot

# Creamos un alias para la aplicación cerbot.

sudo ln -sf /snap/bin/certbot /usr/bin/certbot

# Obtenemos el certificado y configuramos el servidor web Apache.

#sudo certbot --apache

#Ejecutamos el comando certbot.
certbot --apache -m $CERTIFICATE_EMAIL --agree-tos --no-eff-email -d $CERTIFICATE_DOMAIN --non-interactive


#Con el siguiente comando podemos comprobar que hay un temporizador en el sistema encargado de realizar la renovación de los certificados de manera automática.

#systemctl list-timers