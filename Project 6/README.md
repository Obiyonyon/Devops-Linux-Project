# Understanding client-Server architecture with MySQL as RDBMS

A Clien-Server architecture refers, to two or more computers that are connected together over a network to send and receive requests between one another.

A Client, is any devices that is use to connect to the internet e.g Tablet, ipad, mobile phone, Desktop computer and laptops. Your web-browser is also a client
 
 ## Implement Implement a Client-Server Architecture using MySQL Database Management System (DBMS).

 Create and configure two linux-based virtual servers (EC2 instances in AWS) one to represent the SERVER the other for the CLIENT. Install MYSQL-SERVER on the server and install MYSQL-CLIENT on the client.

On AWS console, allow inbound rules on your MYSQL-SERVER on port 3306 which is default for MYSQL-SERVER for MYSQL-CLIENT.

![alt text](<Images/Screenshot 2024-02-28 190641.png>)

Configure MYSQL-SERVER to allow connections from remote hosts sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf edit both addresses from 127.0.0.1 to 0.0.0.0

On your Client Instance: Enter the below command:

mysql -h <hostname> -u <username> -p
hostname: MYSQL-SERVER Public-ipv4 address
username: username set password will be requested on prompt.
then run SHOW DATABASES; You should see the created testdb.

![alt text](<Images/Screenshot 2024-03-05 204852.png>)

CONGRATULATIONS!!!

