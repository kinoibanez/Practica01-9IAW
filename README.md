# Practica01-9IAW
Este repositorio es para la Práctica 1 apartado 9 de IAW. 

- La principal funcionalidad de esta práctica es que tenemos que automatizar la instalación y configuración de una aplicación web LAMP en dos máquinas virtuales.

    Vamos a tener dos *_pilas LAMP_* en dos máquinas diferentes, una se encargara de gestionar las peticiones web y la otra de gestionar la base de datos.

    La arquitectura de esta práctica estará formada de la siguiente manera:

    1. Una capa de *_front_end_*, que estará formada por un servidor web con Apache HTTP server.

    2. Una capa de *_back_end_* , que estará formada por un servidor MySQL.


## Partición de los scripts.

- Como hemos comentado anteriormente, haciendo uso del script que tenemos creado anteriormente *_install_lamp.sh_* tendremos que "partirlo" de manera que quede un apartado para la instalación de Apache2 en el *_front_end_* y la parte de la configuración de MySql en el *_back_end_*


    El script que tenemos que utilizar en el *_front_* para su correspondiente *_install_lamp_* será el siguiente:

    ```
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
            
    ```

    En este script podemos observar como movemos los archivos *_conf_* como hemos hecho anteriormente con otras prácticas como pueden ser: [Práctica 1.7 IAW](https://github.com/kinoibanez/Practica01-7IAW).

    La principal funcionalidad de este script en el *_front_* es instalar apache y configurarlo de manera correcta.

    


-  El script que tenemos que utilizar en el *_back_* para su correspondiente *_install_lamp_* será el siguiente:

    ```
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

    ```

    Como podemos observar en este script hemos declaro una variable nueva que anteriormente no hemos usado que es *_$MYSQL_PRIVATE_IP_*, la cual tenemos que tener configurada con la IP privada del servidor *_back_end_*.

### Archivo de configuración 000-default.conf, *_cerbot_* y .env.

- Este apartado contiene información como anteriormente hemos comentado, que ha sido utilizada en prácticas anteriores, pero siempre es bueno realizar un repaso.

    El archivo 000-default.conf que almacena la configuración de las conexiones de Apache en nuestra máquina tendra que estar de la siguiente manera: 

    ```
        <VirtualHost *:80>
    #ServerName www.example.com
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html
    <Directory "/var/www/html">
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    ```

    Sentencias como *_ERRORLOG_* y *_CUSTOMLOG_* nos permitirán seguir una serie de registros de errores en la máquina.

- Tenemos que instalar cerbot para asi poder configurar la conexión y que sea segura, o que al menos accedamos siempre a través del puerto *_https:443_*, este script lo hemos usado en prácticas anteriores pero siempre es bueno tenerlo a mano.

    ```
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

    ```

- Y por último y no menos importante nuestro archivo *_.env_* que tendrá que tener en su interior todas las variables que hemos ido declarando en los scripts anteriores.

    ![](images/cap1.png)


- Una vez realizado y lanzado lo anterior, ya tendremos el *_install_lamp_* configurado en las dos máquinas, OJO con equivocarse y lanzarlos en la máquina que no es.