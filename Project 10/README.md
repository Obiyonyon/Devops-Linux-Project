# Implementing a business website using NFS for backend storage.

A Network File System (NFS) allows remote hosts to mount file systems over a network and interact with those file systems as though they are mounted locally. This enables system administrators to consolidate resources onto centralized servers on the network.

### 1. Prepare an NFS Server.

* Spin up an EC2 instance with RHEL Linux 9 operating system.

* Configure LVM on the server.

* Ensure there are 3 Logical Volumes. Iv-apps, lv-opt and lv -logs.

* Format the disk as XFS.

* create mount points on /mnt directory for the logical volumes as follows: Mount apps-lv on /mnt/apps. logs-lv on /mnt/log opt-lv on /mnt/opt.

![alt text](<Images/Screenshot 2024-05-03 090111.png>)


### 2. Install NFS Server, configure to start on boot and make sure it's running.

sudo yum -y update 

sudo yum install nfs-utils -y 

sudo systemctl start nfs-server.service 

sudo systemctl enable nfs-server.service 

sudo systemctl status nfs-server.service

### 3. Export the mounts for webservers Subnet cidr to connect as client.

To check your > Subnet cidr - Open your EC2 details in AWS console and locate networking tab and open a Subnet link.

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



Esc + :wq!

sudo exportfs -arv

