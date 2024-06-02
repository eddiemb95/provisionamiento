#!/bin/bash
set -e
# Actualiza la lista de paquetes e instala las dependencias necesarias

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y build-essential curl git wget unzip vim tmux net-tools

cd ~
sudo curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -

sudo apt-get install -y nodejs

 sudo npm install pm2@latest -g
# Clona un repositorio de ejemplo


sudo git clone https://github.com/eddiemb95/Actividad1HerrDevops.git /home/unir

sudo chmod 777 /home/unir


if ! command -v nginx &> /dev/null; then
   sudo  apt-get install -y nginx
fi

sudo rm /etc/nginx/sites-enabled/default
# Crea un archivo de configuración para Nginx
CONFIG_CONTENT=$(cat <<EOF
server {
    listen 80;

    location / {
         proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
)

sudo echo "$CONFIG_CONTENT" > actividad1_devops.conf

sudo cp actividad1_devops.conf /etc/nginx/sites-available/
# Activa el archivo de configuración de Nginx
sudo ln -s /etc/nginx/sites-available/actividad1_devops.conf /etc/nginx/sites-enabled/
# Reinicia Nginx para aplicar los cambios
sudo systemctl restart nginx

cd /home/unir

npm install
 
sudo pm2 start index.js

sudo pm2 startup

sudo pm2 save
