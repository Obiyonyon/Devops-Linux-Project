# Implementing Wordpress Website With LVM Storage Management.

WordPress is a content management system (CMS) that allows you to host and build websites. WordPress contains plugin architecture and a template system, so you can customize any website to fit your business, blog, portfolio, or online store. The focus is not on how to build websites with wordpress.

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