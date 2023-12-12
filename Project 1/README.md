# Linux Project For Commands

## File Manipulation

### 1. Sudo (Superuser do)

Functions: Require to perform task that requires admin or root permissions and access.

![Alt text](<Images/Screenshot 2023-12-04 184505.png>)

### 2. Create pwd command

Functions: Required to find the path for the folder, file or application current/parent working directory or path.


![Alt text](<Images/Screenshot 2023-12-09 134841.png>)

### 3. Create cd command

Functions: required to navigate through files and directory, depends on the current directory.

![Alt text](<Images/Screenshot 2023-12-09 140209.png>)

### 4. Create ls command

Functions: required to list the item in the directory or contents.
The current working directoru is REPOSITORIES\Devops-Linux-Project

![Alt text](<Images/Screenshot 2023-12-09 191426.png>)

### 5. Create cat command -> Concatenate

Functions: Requires to list, combine file content to the standard output and can merge files to another file.
![Alt text](<Images/Screenshot 2023-12-10 101522.png>)

### 6. cp:
Cp is used to copy files or directories, this is majorly used every single day and almost every seconds to copy and paste text, files and folders.

MV is used to move files/folders and text from one location to another.

![Alt text](<Images/Screenshot 2023-12-10 104003.png>)

### 7. Mv:

MV is used to move files/folders and text from one location to another.

Adding flag -R copies/moves the entire directory, depending on the if you're copying or moving files, folders or text.

![Alt text](<Images/Screenshot 2023-12-11 192210.png>)

### 8. Create mkdir is used to create 1 or multiple directories/folders, which also set permissions for each of them.

Functions: Required to make directory.

Run mkdir directoryFolder
To make sub directory inside directory folder as shown above, do:

![Alt text](<Images/Screenshot 2023-12-11 192811.png>)

### 9. rmdir,rm:

Rmdir is basically used to remove or permanently delete an empty director or path folder., Users must have some sudo priviledges to perform this action.

Rm command is basically to delete files within some directory and users performing this actions should have write permissions too

![Alt text](<Images/Screenshot 2023-12-11 200448.png>)

### 10 touch, locate, find, grep:

Touch command is used to create a new file that is empty or also mofidy and generate a timestamp in linux cmd.

Find command is used to search for documents within specific directory or folders and perform operations. //[find] [option] [path] [expression]

Grep command is an acronym for global expression print used to find words by search all text in documents.

![Alt text](<Images/Screenshot 2023-12-12 152504.png>)

### 11 df, du, head, tail, diff, tar:

DU is used to also check how much a folder or file is taking or using.

Head is used to show the first ten lines of a file

TAIL is to check the last ten lines in a file, just as the name implies, Tail -something like end.

DIff as the name impless is difference to look for something.

Tar is used for archive files into a TAR format, somehow like ZIP etc.

![Alt text](<Images/Screenshot 2023-12-12 153941.png>)

### 12. File Permission and Ownership

chmod, chown, jobs, kill, ping, wget, uname, top, history, man, Echo: Chmod from the name means to change mode, used to change access permission and the special mode flags of the system ojects Chmod also modifies files or directory's read and wite, execute permissions. Each file is associated with 3 user classes - owner, group and others.

Chown is used to modify or change owner of directory or file.

Jobs used to display all the running processes along with their statuses, it's only available in csh, bash etc.

Kill used to terminate unresponsive apps or freezing apps. You have to know the process ID number to terminate and run the command.

ping is used to to check wether network or signal is reachable. You can always ping any IP address.

wget this allows files download from the internet, it usually works in the background, it recieves files using HTTPS, HTTP and FTP protocols. wget [option] URL uname this print detailed info about your linux system and hardware, such as MAchine name, OS, kernetl etc. uname -a

Top displays all the running processes and a dynamic real time viiew of the current system. Sums up resource utilization from the CPU to memory usage.

it can be used to terminate apps using too much resources and slwoing the system. Top
History the system will list upto 500 previously executed commands, allowing you to reuse them without re-entering.

Only users with SUDO priviledges can execute this command History [option]
man prides user manual of any commands or utilities you can run in a terminal, including the name, description and options etc. man [command_name] man ls man [option] [section_number] [command_name] etc


### 13. echo command

Echo is used to display line of text, echo is a syntax of PHP backend language too.

![Alt text](<Images/Screenshot 2023-12-12 161639.png>)