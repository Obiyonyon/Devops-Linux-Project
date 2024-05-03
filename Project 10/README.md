# Implementing a business website using NFS for backend storage.

A Network File System (NFS) allows remote hosts to mount file systems over a network and interact with those file systems as though they are mounted locally. This enables system administrators to consolidate resources onto centralized servers on the network.

* Spin up an EC2 instance with RHEL Linux 9 operating system.

* Configure LVM on the server.

* Ensure there are 3 Logical Volumes. Iv-apps, lv-opt and lv -logs.

* Format the disk as XFS.

* create mount points on /mnt directory for the logical volumes as follows: Mount apps-lv on /mnt/apps. logs-lv on /mnt/log opt-lv on /mnt/opt.

![alt text](<Images/Screenshot 2024-05-03 090111.png>)


### Install NFS Server, configure to start on boot and make sure it's running.

sudo yum -y update 

sudo yum install nfs-utils -y 

sudo systemctl start nfs-server.service 

sudo systemctl enable nfs-server.service 

sudo systemctl status nfs-server.service
