# Implementing Wordpress Website With LVM Storage Management.

WordPress is a content management system (CMS) that allows you to host and build websites. WordPress contains plugin architecture   
and a template system, so you can customize any website to fit your business, blog, portfolio, or online store. The focus is not on how to build websites with wordpress.

But to prepare storage infrastructure on two Linux servers and implement a basic web solution using WordPress. WordPress is a free and open-source content management system written in PHP and paired with MySQL or MariaDB as its backend Relational Database Management System (RDBMS).

## This Project Consist Of Two Parts:
+ Configure storage subsystem for Web and Database servers based on Linux OS.
 The focus of this part is to give you practical experience of working with disks, partitions and volumes in Linux.

* Install WordPress and connect it to a remote MySQL database server. This part of the project will solidify your skills of deploying Web and DB tiers of Web solution.

As a DevOps engineer, a deep understanding of core components of web solutions and the ability to troubleshoot them will play essential role in your further progress and development.

## Three Tier Architecture

Generally, web, or mobile solutions are implemented based on what is called the Three-tier Architecture.

Three-tier Architecture is a client-server software architecture pattern that comprise of 3 separate layers. They are:

+ **Presentation Layer (PL)**: This is the user interface such as the client server or browser on your laptop.

+ **Business Layer (BL)**: This is the backend program that implements business logic. Application or Webserver.

+ **Data Access or Management Layer (DAL)**: This is the layer for computer data storage and data access. Database Server or File System Server such as FTP server, or NFS Server.


With this project, you will have the hands-on experience that showcases Three-tier Architecture while also ensuring that the disks used to store files on the Linux servers are adequately partitioned and managed through programs such as gdisk and LVM respectively.

Requirements:

## Your 3-Tier Setup

+ A Laptop or PC to serve as a client
+ An EC2 Linux Server as a web server (This is where you will install WordPress).
+ An EC2 Linux server as a database (DB) server

**Note:** We are using RedHat OS for this project, you should be able to spin up an EC2 instance on your own. Also when connecting to RedHat you will need to use ec2-user user. Connection string will look like ec2-user@public-ip-address.

## Creating And Mounting New Volumes

+ Create and attach a new volume to your Linux 
server.

![alt text](<Images/Screenshot 2024-04-16 112530.png>)

**Note:** Ensure that the availability zone of your volume must be the same as your Linux server.

Attach all the three volumes one by one to your Web Server EC2 
![alt text](<Images/Screenshot 2024-04-17 105117.png>)

 ## Open up the Linux terminal to begin configuration

Use lsblk command to inspect what block devices are attached to the server.

Notices names of your newly created devices All devices in Linux resides in
/dev/directory. Inspect it with ls/dev/ to see all 3 newly created block devices there. Their names will likely be xvdb, xvdc, xvdd.

![alt text](<Images/Screenshot 2024-04-17 105856.png>)

+ Use df -h command to see all mounts and free space on your server.

+ Use gdisk utility to create a single partition on each of the 3 disk.
sudo gdisk /dev/xvdb.

![alt text](<Images/Screenshot 2024-04-17 124326.png>)
![alt text](<Images/Screenshot 2024-04-17 134045.png>)

![alt text](<Images/Screenshot 2024-04-17 140035.png>)

Install lvm2 package using sudo yum install lvm2 -y  
Run sudo lvmdiskscan command to check for available partitions.

Verify that your Physical volume has been created successfully by running sudo pvs.

![alt text](<Images/Screenshot 2024-04-17 170002.png>)

Use vgcreate utility to add all 3 PVs to a volume group(VG).Name the VG webdata-vg.

Verify that your VG has been created successfully by running sudo vgs

![alt text](<Images/Screenshot 2024-04-17 225607.png>)

Use lvcreate utility to create 2 logical volumes.apps -lv (use half of the PV size), and logs -lv. Use the remain space of the PV size. Note apps-lv will be used to store data for the website while, log-lv will be used to store data for logs.

sudo lvcreate -n apps-lv -L 14G webdata-vg

sudo lvcreate -n logs-lv -L 14G webdata-vg

Verify that your logical volume has been created successfully by running sudo lvs

![alt text](<Images/Screenshot 2024-04-17 230850.png>)

Verify the entire setup

sudo vgdisplay -v #view complete setup - VG, PV, and LV

sudo lsblk

![alt text](<Images/Screenshot 2024-04-17 231831.png>)

Use mkfs.ext4 to format the logical volume with ext4 filesystem.
sudo mkfs -t ext4 /dev/webdata-vg/apps-lv

sudo mkfs -t ext4 /dev/webdata-vg/logs-lv

Create **/var/www/html** directory to store website files 

sudo mkdir -p /var/www/html

Create **/home/recovery/logs** to store backup of log data

sudo mkdir -p /home/recovery/logs

Mount **/var/www/html** on apps-lv logical volume

sudo mount /dev/webdata-vg/apps-lv /var/www/html/

Use rsyn utility to backup all the files in the log directory **/var/log into /home/recovery/logs** *(This is required before mounting the file system)*.

sudo rsync -av /var/log/. /home/recovery/logs/

Mount **/var/log on logs-lv** logical volume. (Note that all the existing data on/var/log will be deleted).

sudo mount /dev/webdata-vg/logs-lv /var/log

Restore log files back into **/var/log**  
directorysudo rsync -av /home/recovery/logs/log/ /var/log

Update /etc/fstab file so that the mount configuration will persist after restart of the server.

The UUID of the device will be used to update the /etc/fstab file;

sudo blkid

![alt text](<Images/Screenshot 2024-04-18 120759.png>)


sudo vi /etc/fstab

Update /etc/fstab in this format using your own UUID and remember to remove the leading and ending quotes.

![alt text](<Images/Screenshot 2024-04-18 123005.png>)

Test the configuration and reload the daemon
  
sudo mount -a    

sudo systemctl daemon-reload

Verify your setup by running df -h, output must look like this:

![alt text](<Images/Screenshot 2024-04-18 124009.png>)

# Installing wordpress and configuring to use MySQL Databse.

Prepare the Database server

Launch a second Redhat ec2 instance that will have a role -'DB Server' Repeat the same steps as for the web server, but instead of apps-lv create db-lv and mount it to /db directory instead of /var/www/html.


**Install wordpress on your web server EC2**  

Update the repository
sudo yum -y update

Install wget, Apache and it's dependencies

sudo yum -y install wget httpd php php-mysqlnd php-fpm php-json

**Start Apache**

sudo systemctl enable httpd 

sudo systemctl start 

**Install PHP and it's dependencies**

sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum install yum-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo yum module list php
sudo yum module reset php
sudo yum module enable php:remi-7.4
sudo yum install php php-opcache php-gd php-curl php-mysqlnd
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
setsebool -P httpd_execmem 1

**Restart Apache**

sudo systemctl restart httpd

Download wordpress and copy wordpress to var/www/html

mkdir wordpress
cd   wordpress
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo rm -rf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cp -R wordpress /var/www/html/

**Configure SELinux Policies**

 sudo chown -R apache:apache /var/www/html/wordpress
 sudo chcon -t httpd_sys_rw_content_t /var/www/html/wordpress -R
 sudo setsebool -P httpd_can_network_connect=1

 **Install MySQL on your DB Server EC2**

 sudo yum update 

sudo yum install mysql-server

Verify that service is up and running by using sudo systemctl status mysqld, if it is not running, restart the service and enable it so it will be running even after reboot:

sudo systemctl restart 

sudo systemctl enable mysqld

**Configure DB to work with wordpress**

sudo mysql
CREATE DATABASE wordpress;
CREATE USER `myuser`@`<Web-Server-Private-IP-Address>` IDENTIFIED BY 'mypass';
GRANT ALL ON wordpress.* TO 'myuser'@'<Web-Server-Private-IP-Address>';
FLUSH PRIVILEGES;
SHOW DATABASES;
exit

**Configure wordpress to connect to remote database.**

**Hint:** Do not forget to open MySQL port 3306 on DB server EC2. For extra security, you shall allow access to the DB server ONLY from web server's IP address, so in the Inbound Rule configuration specify source as /32.

![alt text](<Images/Screenshot 2024-04-18 213937.png>)

Install MySQL client and test that you can connect from your Web Server to your DB server by using mysql-client

sudo yum install mysql

sudo mysql -u admin -p -h

DB-Server-Private IP-

* Verify if you can successfully execute SHOW DATABASE; command and see a list of existing database.

* existing database.
Change permission and configuration so Apache coulduse Wordpress.

* Enable TCP port80 in Inbound Rules configuration for your Web Server EC2 (enable from everywhere 0.0.0.0/0 or from your workstation's IP).

* Try to access from your browser the link to your Wordpress.

![alt text](<Images/Screenshot 2024-04-18 213409.png>)
![alt text](<Images/Screenshot 2024-04-18 213428.png>)![alt text](<Images/Screenshot 2024-04-18 213454.png>)