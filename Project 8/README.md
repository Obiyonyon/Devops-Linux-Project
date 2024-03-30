# Automating Load Balancer Configuration With Shell Scripting.

Automating Load balancer Configuration With Shell Scripting refers to the process of using shell scripts to automate the setup and management of load balancers in a computing environment. These scripts are designed to streamline the often complex and repetitive tasks associated with configuring load balancers, such as defining routing rules and server pools.

By automating load balancer configuration, Engineers can achieve greater efficiency and scalability in their network infrastructure, reducing the risk of human errors and improving overall system reliability. This approach is particularly valuable in DevOps and cloud computing environments, where rapid and consistent load balancer setup is essential for optimizing resource allocation and application performance.

# Automate the deployment of web servers:

We will be writing a script that automates the installation and configuration of the Apache web server to listen on port 8000. It does this by updating the package list, installing the Apache2 package, checking if the Apache2 service is running, and modifying the necessary configuration files. It also creates an index.html file in the /var/www/html directory with a welcome message and the public IP address of the EC2 instance. Finally, it restarts the Apache2 service.

We will also be writing another script that automates the configuration of Nginx to act as a load balancer. It does this by installing Nginx, creating a new configuration file, and modifying it to specify the upstream servers and configure Nginx to listen on port 80. It then tests the configuration and restarts the Nginx service.

# Deploying and configuring web servers
* Provision an EC2 instance running ubuntu 20.04.
* Inbound Rules: Allow Traffic From Anywhere On Port 8000 and Port 22.

![alt text](<Images/Screenshot 2024-03-30 154626.png>)

* Connect to the 1st Web Server via the terminal

![alt text](<Images/Screenshot 2024-03-30 161924.png>)
* Create and open a file install.sh using the command shown below:

sudo vi install.sh

#!/bin/bash

####################################################################################################################
##### This automates the installation and configuring of apache webserver to listen on port 8000
##### Usage: Call the script and pass in the Public_IP of your EC2 instance as the first argument as shown below:
######## ./install_configure_apache.sh 18.234.230.94
####################################################################################################################

set -x # debug mode
set -e # exit the script if there is an error
set -o pipefail # exit the script when there is a pipe failure

PUBLIC_IP=18.234.230.94

[ -z "${PUBLIC_IP}" ] && echo "Please pass the public IP of your EC2 instance as an argument to the script" && exit 1

sudo apt update -y &&  sudo apt install apache2 -y

sudo systemctl status apache2

if [[ $? -eq 0 ]]; then
    sudo chmod 777 /etc/apache2/ports.conf
    echo "Listen 8000" >> /etc/apache2/ports.conf
    sudo chmod 777 -R /etc/apache2/

    sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8000>/' /etc/apache2/sites-available/000-default.conf

fi
sudo chmod 777 -R /var/www/
echo "<!DOCTYPE html>
        <html>
        <head>
            <title>My EC2 Instance</title>
        </head>
        <body>
            <h1>Welcome to my 1st Web Server EC2 instance</h1>
            <p>Public IP: "${PUBLIC_IP}"</p>
        </body>
        </html>" > /var/www/html/index.html

sudo systemctl restart apache2

