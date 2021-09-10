#!/bin/bash

#Updating OS
sudo apt update && sudo apt upgrade -y

sudo apt install apache2 -y
sudo service apache2 restart

sudo > /var/www/html/index.html
sudo printf "
    <!DOCTYPE html>
  <html>
   <head>
    <meta charset="utf-8" />
    <title>HTML5</title>
   </head>
   <body>
    <p>Hello from back</p>
   </body>
  </html>
   " > /var/www/html/index.html
   sudo service apache2 restart


