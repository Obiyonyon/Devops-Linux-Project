#!/bin/bash

#Installing Web Server Dependencies
echo "#############################"
echo "Installing Dependencies"
echo "#############################"
apt update -y > /dev/null
apt install -y wget unzip apache2 > /dev/null
echo

#Create directory
echo "#############################"
echo "Create directory"
echo "#############################"
mkdir -p /tmp/webfiles
cd  /tmp/webfiles

wget https://www.tooplate.com/zip-templates/2106_soft_landing.zip > /dev/null
unzip 2106_soft_landing.zip > /dev/null
cp -r  2106_soft_landing/* /var/www/html/
echo
