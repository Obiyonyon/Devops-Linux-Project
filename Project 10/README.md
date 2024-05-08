# Implementing a business website using NFS for backend storage.

A network file system (NFS) allows a user on a client computer to access files over a computer network much like local storage is accessed. NFS, like many other protocols, builds on the Open Network Computing Remote Procedure Call (ONC RPC) system.

**Infrastructure:** AWS 

**Webserver Linux:** Red Hat Enterprise Linux 8 

**Database Server:** Ubuntu 20.04 + MySQL 

**Storage Server:** Red Hat Enterprise Linux 8 + NFS Server 

**Programming Language:** PHP
**Code Repository:** Github

### 1. Prepare an NFS Server.

* Spin up an EC2 instance with RHEL Linux 8 operating system.

* Configure LVM on the server.
* Use gdisk utility to create a single partition on 
 each of the 3 disks.

 ![alt text](<Images/Screenshot 2024-05-06 115045.png>)

* Then install the lvm2 package using the following  
command: sudo yum install lvm2

* run the following command to check for available   
  partitions: sudo lvmdiskscan.

  ![alt text](<Images/Screenshot 2024-05-06 115730.png>)
* Now after checking that there's no logical volume present, we need to create a physical volume on each of the 3 disks using the following command:
sudo pvcreate

![alt text](<Images/Screenshot 2024-05-06 170846.png>)

* Now we need to verify that our physical volume has been created successfully using the following command:
sudo pvs

![alt text](<Images/Screenshot 2024-05-06 171210.png>)
* Now we need to create a volume group using the vgcreate utility. We will use the 3 disks we created earlier to create a volume group called NFS-vg. 

   sudo vgcreate nfs-vg /dev/xvdb1 /dev/xvdc1 /dev/xvdd1.
![alt text](<Images/Screenshot 2024-05-06 173052.png>)

* Use lvcreate utility to create 3 logical volumes. lv-opt lv-apps, and lv-logs. The lv-apps: would be used by the webservers, The lv-logs: would be used by web server logs, and the lv-opt: would be used by the Jenkins server.

  sudo lvcreate -L 10G -n lv-opt nfs-vg 

  sudo lvcreate -L 10G -n lv-apps nfs-vg 

  sudo lvcreate -L 10G -n lv-logs nfs-vg

  ![alt text](<Images/Screenshot 2024-05-06 174205.png>)

* Now we need to verify that our logical volumes have been created successfully using the following command:
sudo lvs

![alt text](<Images/Screenshot 2024-05-06 174955.png>)

* Verify the entire setup

![alt text](<Images/Screenshot 2024-05-06 175320.png>)

* Use mkfs.xfs to format the logical volumes with xfs filesystem.

   sudo mkfs -t xfs /dev/nfs-vg/lv-opt 

   sudo mkfs -t xfs /dev/nfs-vg/lv-apps

   sudo mkfs -t xfs /dev/nfs-vg/lv-logs

![alt text](<Images/Screenshot 2024-05-06 175713.png>)


* Create a directory for each of the logical volumes.

![alt text](<Images/Screenshot 2024-05-06 180458.png>)

* Mount the logical volumes to the directories we created earlier.

![alt text](<Images/Screenshot 2024-05-06 181130.png>)

* Verify that the logical volumes have been mounted successfully. using the command: sudo df -h

![alt text](<Images/Screenshot 2024-05-06 181509.png>)

* Now we need to make the mount persistent. To do that, we need to edit the /etc/fstab file and add the following lines: 

  sudo blkid 

  sudo vi /etc/fstab

![alt text](<Images/Screenshot 2024-05-06 184448.png>)

* Now we need to test the configurations and reload the daemon.

  using this command: sudo mount -a 

  sudo systemctl daemon-reload

![alt text](<Images/Screenshot 2024-05-06 185015.png>)

### 2. Install NFS Server, configure to start on boot and make sure it's running.

sudo yum -y update 

sudo yum install nfs-utils -y 

sudo systemctl start nfs-server.service 

sudo systemctl enable nfs-server.service 

sudo systemctl status nfs-server.service

![alt text](<Images/Screenshot 2024-05-03 183729.png>)

### 3. Export the mounts for webservers Subnet cidr to connect as client.

To check your Subnet cidr - Open your EC2 details in AWS console and locate networking tab and open a Subnet link.

![alt text](<Images/Screenshot 2024-05-03 095958.png>)

### 4. Setup permission that will allow Webservers to read, write and execute files on NFS.

sudo chown -R nobody: /mnt/apps 

sudo chown -R nobody: /mnt/logs 

sudo chown -R nobody: /mnt/opt

sudo chmod -R 777 /mnt/apps

sudo chmod -R 777 /mnt/logs

sudo chmod -R 777 /mnt/opt

sudo systemctl restart nfs-server.service

![alt text](<Images/Screenshot 2024-05-06 191541.png>)
### 5. Configure access to NFS for clients within the same Subnet (Subnet cidr 172.31.16.0/20).

* Now we need to edit the /etc/exports file and add the following lines:

  sudo vi /etc/exports

  /mnt/apps <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash) 

  /mnt/logs <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash) 

  /mnt/opt <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash)

  *Note* change the subnet-cidr to the IP address created.

* and then run the command:

  sudo exportfs -arv

![alt text](<Images/Screenshot 2024-05-06 195644.png>)

### 6. Check which port is used by NFS and open it using security groups (add new inbound rules).

rpcinfo -p | grep nfs

![alt text](<Images/Screenshot 2024-05-03 115429.png>)

![alt text](<Images/Screenshot 2024-05-03 114534.png>)

Note: For the NFS server to be accessible from your client, you must also open the following ports: TCP 111, UDP 111, and UDP 2049.

# Configure the database server

1. Create a new instance of ubuntu and ssh into it.

![alt text](<Images/Screenshot 2024-05-04 191059.png>)
2. Install the MySQL server using the following 
command:

sudo apt install mysql-server

![alt text](<Images/Screenshot 2024-05-04 192126.png>)

3. Create a database name called tooling

   sudo mysql 

 CREATE DATABASE tooling;

![alt text](<Images/Screenshot 2024-05-06 201721.png>)

![alt text](<Images/Screenshot 2024-05-04 200146.png>)

4. Create a database user and name it webaccess

  CREATE USER 'webaccess'@'%' IDENTIFIED BY 'password';

Note: The '%' should be replaced with the address of the subnet CIDR of your webservers.

![alt text](<Images/Screenshot 2024-05-04 201954.png>)

5. Grant the webaccess user all privileges on the tooling database.

GRANT ALL PRIVILEGES ON tooling.* TO 'webaccess'@'%';

![alt text](<Images/Screenshot 2024-05-04 202902.png>)

6. Now we need to flush all privileges.

FLUSH PRIVILEGES;

![alt text](<Images/Screenshot 2024-05-04 203050.png>)

7. Now let's show our databases and users.

SHOW DATABASES;

![alt text](<Images/Screenshot 2024-05-04 203242.png>)

8. Now let's navigate to the tooling database and show tables.

USE tooling; 

SHOW TABLES;

![alt text](<Images/Screenshot 2024-05-04 203451.png>)

#  Configure the web servers

1. Create a new instance of RedHat and ssh into it.
2. Install NFS client using the following command:

sudo yum install -y nfs-utils nfs4-acl-tools

![alt text](<Images/Screenshot 2024-05-05 135612.png>)

3. Create a directory called /var/www/ and target the NFS server's export for apps.

sudo mkdir /var/www 

sudo mount -t nfs -o rw,nosuid 172.31.27.93:/mnt/apps-lv /var/

*Note* use the private IP of the NFS-server to mount

![alt text](<Images/Screenshot 2024-05-07 211913.png>)

Verify that NFS was mounted successfully.

using this command: sudo df -h

![alt text](<Images/Screenshot 2024-05-07 222005.png>)

Make sure that the changes will persist on the web server after reboot. 

sudo vi /etc/fstab

add the following: 

NFS-IP-SERVER :/mnt/apps /var/www nfs defaults 0 0

![alt text](<Images/Screenshot 2024-05-07 222908.png>)

Install Remi's repository, Apache and PHP

sudo yum install httpd -y

sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

sudo dnf module reset php

sudo dnf module enable php:remi-7.4

sudo dnf install php php-opcache php-gd php-curl php-mysqlnd

sudo systemctl start php-fpm

sudo systemctl enable php-fpm

setsebool -P httpd_execmem 1

![alt text](<Images/Screenshot 2024-05-07 224112.png>)


Repeat the previous step for another 2 Web Servers.

To verify that Apache files and directories are available on the Web Server in /var/www and also on the NFS server in /mnt/apps. If you see the same files – it means NFS is mounted correctly. You can try to create a new file touch test.txt from one server and check if the same file is accessible from other Web Servers. Use the command:

sudo touch test.txt

![alt text](<Images/Screenshot 2024-05-08 092743.png>)

Now we need to locate the log folder for Apache on the web server and mount it to the NFS server's export for logs and make sure that the changes will persist on the web server after reboot on all the web servers.

sudo mkdir /var/log/httpd 

sudo mount -t nfs -o rw,nosuid 172.31.27.93:/mnt/apps /var/log/httpd

and then add the following to /etc/fstab:

![alt text](<Images/Screenshot 2024-05-08 105238.png>)

Now we need to install git on any of the web servers. 

sudo yum install git

![alt text](<Images/Screenshot 2024-05-08 114040.png>)

Now we need to clone the repository from GitHub to the web server.

![alt text](<Images/Screenshot 2024-05-08 120037.png>)

And now we need to copy the files from the html folder in the repository to the /var/www/html directory.

cd tooling
sudo cp -r html/* /var/www/html/

and to verify that the files were copied successfully:

![alt text](<Images/Screenshot 2024-05-08 120753.png>)

Note: If you encounter 403 Error – check permissions to your /var/www/html folder and also disable SELinux sudo setenforce 0. To make this change permanent – open following config file sudo nano /etc/sysconfig/selinux and set SELINUX=disabledthen restrt httpd.

Now we need to update the website’s configuration to connect to the database (in /var/www/html/functions.php file).

![alt text](<Images/Screenshot 2024-05-08 122958.png>)