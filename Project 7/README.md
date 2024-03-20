# Setting up a Load-balancer

* Launch two EC2 Instances running ubuntu 22.04. 
* Install Apache webserver in them.
* Open port 8000 to allow traffic from anywhere.
* Update the default page of webservers to display IP addresses.

Open port 8000 we will be running webservers on port 8000, while the load balancer runs on port 80. We need to open port 8000 to allow traffic from anywhere. To do this we need, to add a rule to the security group of each webservers.

![alt text](<Images/Screenshot 2024-03-11 175018.png>)

## Install Apache

![alt text](<Images/Screenshot 2024-03-11 180057.png>)

![alt text](<Images/Screenshot 2024-03-11 180150.png>)

## Configure Apache to server page showing its public IP:
We, will start by configuring Apache webserver, to serve content on port 8000 instead of its default which is port 80. 

Then we will create a new index.html file.
The file will, contain code to display the public IP of the EC2 instance. We will then override apache webserver's default html file with our new file.

### Configuring Apache to serve content on port 8000
sudo vi /etc/apache2/ports.conf 

Add a new listen directive for port 8000

![alt text](<Images/Screenshot 2024-03-11 182352.png>)

Next open the file /etc/apache2/sites-available/000-default.conf and change port 80 on virtualhost to 8000.

![alt text](<Images/Screenshot 2024-03-11 184848.png>)

Restart apache to load the new configuration using the comman below:

sudo systemctl restart apache2

## Create a new html file
sudo vi index.html

     <!DOCTYPE html>
        <html>
        <head>
            <title>My EC2 Instance</title>
        </head>
        <body>
            <h1>Welcome to my EC2 instance</h1>
            <p>We swiftly analyze information</p>
        </body>
        </html>

Change file ownership of the index.html file with command below:

   sudo chown www-data:www-data ./index.html

   ## Overriding the default html file of Apache webserver

   * Replace the default html file with our new hmtl file using the command below:

   sudo cp -f ./index.html /var/www/html/index.html

   Restart the webserver to load the new configuration using the command below:

   sudo systemctl restart apache2

![alt text](<Images/Screenshot 2024-03-11 201027.png>)

## Configuring Nginx as a load balancer

* Launch a new EC2 instance running unbuntu 22.04.
* Make sure port 80 is opened to accept traffic from anywhere
* Install Nginx 

![alt text](<Images/Screenshot 2024-03-11 202022.png>)

![alt text](<Images/Screenshot 2024-03-11 202054.png>)

Open Nginx configuration file with the command below:
sudo vi /etc/nginx/conf.d/loadbalancer.conf


        
        upstream backend_servers {

            # your are to replace the public IP and Port to that of your webservers
            server 127.0.0.1:8000; # public IP and port for webserser 1
            server 127.0.0.1:8000; # public IP and port for webserver 2

        }

        server {
            listen 80;
            server_name <your load balancer's public IP addres>; # provide your load balancers public IP address

            location / {
                proxy_pass http://backend_servers;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            }
        }
    
* Test your configuration with the command below:

sudo nginx -t

![alt text](<Images/Screenshot 2024-03-11 202544.png>)

* If there are no errors, restart Nginx to load the new configuration with the command below:

sudo systemctl restart nginx

![alt text](<Images/Screenshot 2024-03-20 131723.png>)