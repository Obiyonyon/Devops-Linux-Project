# Implementing a business website using NFS for backend storage.

A network file system (NFS) allows a user on a client computer to access files over a computer network much like local storage is accessed. NFS, like many other protocols, builds on the Open Network Computing Remote Procedure Call (ONC RPC) system.

**Infrastructure:** AWS 

**Webserver Linux:** Red Hat Enterprise Linux 8 

**Database Server:** Ubuntu 20.04 + MySQL 

**Storage Server:** Red Hat Enterprise Linux 8 + NFS Server 

**Programming Language:** PHP
**Code Repository:** Github

### 1. Prepare an NFS Server.

* Spin up an EC2 instance with RHEL Linux 9 operating system.

* Configure LVM on the server.

* Ensure there are 3 Logical Volumes. Iv-apps, lv-opt and lv -logs.

* Format the disk as XFS.

* create mount points on /mnt directory for the logical volumes as follows: Mount apps-lv on /mnt/apps. logs-lv on /mnt/log opt-lv on /mnt/opt.

![alt text](<Images/Screenshot 2024-05-03 180011.png>)

* Mount the logical volumes to the directories we created earlier.

![alt text](<Images/Screenshot 2024-05-03 171915.png>)

* Verify that the logical volumes have been mounted successfully.

![alt text](<Images/Screenshot 2024-05-03 172143.png>)

* Update /etc/fstab file so that the mount configuration will persist after restart of the server.

![alt text](<Images/Screenshot 2024-05-03 182953.png>)

* Now we need to test the configurations and reload the daemon.

![alt text](<Images/Screenshot 2024-05-03 183417.png>)

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

sudo chown -R nobody: /mnt/apps-lv 

sudo chown -R nobody: /mnt/logs-lv 

sudo chown -R nobody: /mnt/opt-lv

sudo chmod -R 777 /mnt/apps-lv 

sudo chmod -R 777 /mnt/logs-lv 

sudo chmod -R 777 /mnt/opt-lv

sudo systemctl restart nfs-server.service

### 5. Configure access to NFS for clients within the same Subnet (Subnet cidr 172.31.16.0/20).

sudo vi /etc/exports

/mnt/apps-lv <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash) 

/mnt/logs-lv <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash) 

/mnt/opt-lv <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash)

*Note* change the subnet-cidr to the IP address created.

Esc + :wq!

sudo exportfs -arv

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