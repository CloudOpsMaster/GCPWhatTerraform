#! /bin/bsh
#Updating OS
sudo apt update && sudo apt upgrade -y
echo "Installing nginx"
#sudo apt install nginx
echo "Setting up input web servers"
sudo sed '/proxy_pass /s/.*# //' -i /etc/nginx/sites-available/default
sudo sed -i 's/localhost: 8080/backend/g' /etc/nginx/sites-available/default
sudo printf "
upstream backend {
server google.com weight=6; 
server google.com weight=4;
}
" >> /etc/nginx/sites-available/default
sudo service nginx restart
sudo service nginx status