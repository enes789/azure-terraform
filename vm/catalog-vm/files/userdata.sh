#!/bin/bash

# install dotnet
apt-get update
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update && \
  apt-get install -y dotnet-sdk-6.0
apt-get update && \
  apt-get install -y aspnetcore-runtime-6.0

# run catalog app
cd /home/azureuser
git clone https://github.com/enes789/azure-projects.git
chown azureuser:azureuser -R azure-projects/
cd azure-projects/catalog
dotnet publish -o publish
nohup dotnet publish/catalog.dll &  

# install nginx 
sudo apt install nginx-full -y

# update nginx conf
cat <<EOT >> /etc/nginx/conf.d/catalog.conf
server {
  listen        80;
  location / {
      proxy_pass         http://127.0.0.1:5000;
      proxy_http_version 1.1;
      proxy_set_header   Upgrade \$http_upgrade;
      proxy_set_header   Connection keep-alive;
      proxy_set_header   Host \$host;
      proxy_cache_bypass \$http_upgrade;
      proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto \$scheme;
  }
}
EOT
rm -rf /etc/nginx/sites-enabled/default

# reload nginx
nginx -s reload
