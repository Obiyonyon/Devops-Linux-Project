# Setting up a Load-balancer

Launch two EC2 Instances running ubuntu 22.04. 
Install Apache webserver in them.
Open port 8000 to allow traffic from anywhere.
Update the default page of webservers to display IP addresses.

Open port 8000 we will be running webservers on port 8000, while the load balancer runs on port 80. We need to open port 8000 to allow traffic from anywhere. To do this we need, to add a rule to the security group of each webservers.

![alt text](<Images/Screenshot 2024-03-11 175018.png>)

Install Apache

(<Images/Screenshot 2024-03-11 180057.png>)

![alt text](<Images/Screenshot 2024-03-11 180150.png>)