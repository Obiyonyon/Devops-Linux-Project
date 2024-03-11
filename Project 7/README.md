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