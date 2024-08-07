#!/bin/sh

# Define variables
CURRENT_DIR=$(pwd)
WEB_DIR="/var/www/pppwn"
NGINX_CONF="/etc/nginx/nginx.conf"
PPPWN_SERVICE="/etc/init.d/pppwn"
CONFIG_DIR="/etc/pppwn"
CONFIG_FILE="$CONFIG_DIR/config.json"

# Change permissions of the following files
chmod +x ./pppwn
chmod +x ./run.sh
chmod +x ./web-run.sh

# Create configuration directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p $CONFIG_DIR
fi

# Create the config.json file with the install directory if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    tee $CONFIG_FILE > /dev/null <<EOL
{
    "FW_VERSION": "1100",
    "HEN_TYPE": "goldhen",
    "TIMEOUT": "5",
    "WAIT_AFTER_PIN": "2",
    "GROOM_DELAY": "4",
    "BUFFER_SIZE": "0",
    "AUTO_RETRY": true,
    "NO_WAIT_PADI": true,
    "REAL_SLEEP": false,
    "AUTO_START": false,
    "install_dir": "$CURRENT_DIR"
}
EOL
    chmod 777 $CONFIG_FILE
fi

# Remove the web directory if it already exists
if [ -d "$WEB_DIR" ]; then
    rm -rf $WEB_DIR
fi

# Set up the web directory
mkdir -p $WEB_DIR
cp -r $CURRENT_DIR/web/* $WEB_DIR/
chmod -R 755 $WEB_DIR

# Set up Nginx configuration
cat <<EOL > /etc/nginx/nginx.conf
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  localhost;
    
        location / {
            root   /var/www/pppwn;
            index  index.php index.html index.htm;
        }
        
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /var/www/pppwn;
        }
    
        location ~ \.php$ {
            root           /var/www/pppwn;
            fastcgi_pass   unix:/var/run/php-fpm.sock;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
            include        fastcgi_params;
        }
    
        location ~ /\.ht {
            deny  all;
        }
    }
}
EOL

# Create PPPwn service
cp ./run.sh /etc/init.d/S99pppwn-service
chmod +x /etc/init.d/S99pppwn-service



# Set up pppoe configuration
cp $CURRENT_DIR/pppoe/pppoe-server-options /etc/ppp/
cp $CURRENT_DIR/pppoe/pap-secrets /etc/ppp/

echo "Installation complete."

reboot
