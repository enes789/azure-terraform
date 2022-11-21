#!/bin/bash

apt update -y
apt install git -y
apt install nodejs -y
cd /home/azureuser && git clone https://github.com/memilavi/weatherAPI.git
cd weatherAPI
apt install npm -y
npm start
