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

1. Create a new instance of RedHat and ssh into it.
2. Install NFS client using the following command:

sudo yum install -y nfs-utils nfs4-acl-tools

![alt text](<Images/Screenshot 2024-05-05 135612.png>)

3. Create a directory called /var/www/ and target the NFS server's export for apps.

sudo mkdir /var/www 

sudo mount -t nfs -o rw,nosuid 172.31.16.0:/mnt/apps-lv /var/www