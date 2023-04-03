#!/bin/bash
sudo apt-get update -y &&
sudo apt install apache2 -y &&
sudo systemctl start apache2
sudo systemctl enable apache2
sudo echo "hi its vijay" > /var/www/html/index.html
sudo systemctl restart apache2
