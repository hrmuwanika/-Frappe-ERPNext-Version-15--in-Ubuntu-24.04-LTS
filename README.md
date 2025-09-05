# Installing ERPNext Frappe on Ubuntu 24.04 LTS

## Software Requirements
- Updated Ubuntu 24.04
- A user with sudo privileges

## Hardware Requirements
- 4GB RAM
- 40GB Hard Disk

## Pre-requisites
  - Python 3.11+                                  (python 3.12 is inbuilt in Ubuntu 24.04 LTS)
  - Node.js 18+
  - Redis 5                                       (caching and real time updates)
  - MariaDB 10.3.x / Postgres 9.5.x               (to run database driven apps)
  - yarn 1.12+                                    (js dependency manager)
  - pip 20+                                       (py dependency manager)
  - wkhtmltopdf (version 0.12.5 with patched qt)  (for pdf generation)
  - cron                                          (bench's scheduled jobs: automated certificate renewal, scheduled backups)
  - NGINX                                         (proxying multitenant sites in production)

#### Refer this for default python 3.11 setup

- [D-codeE Video Tutorial] (https://youtu.be/zU41gq7nji4)


> ## Note:
> Ubuntu 24.04 default python version is python3.12
> 
> Ubuntu 24.04 default mariadb version is 10.11

### Update and Upgrade Packages
First, update your package list and upgrade your installed packages to ensure you’re starting with the latest versions.

    sudo apt update -y && sudo apt upgrade -y

### Install ufw 
    sudo apt install -y ufw
    
    sudo ufw enable
    sudo ufw allow 22/tcp
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw allow 3306/tcp
    sudo ufw allow 8000/tcp
    sudo ufw reload

### Create a new user – (Frappe Bench User)
create a new user for running the Frappe Bench.

    sudo adduser frappe
    sudo usermod -aG sudo frappe
    su frappe
    cd /home/frappe
    
### Install git
Git is required for version control and to clone repositories.

    sudo apt install -y git

### Install -y python3-dev 
Install Python 3.12 and its development tools.

    sudo apt install -y python3-dev 

### Install setuptools and pip (Python's Package Manager).

    sudo apt install -y python3-setuptools python3-pip 

### Install virtualenv
Set up a virtual environment for Python 3.12.
 
    sudo apt install -y python3.12-venv

### Install Common Software Properties
Install the necessary software properties.

    sudo apt install -y software-properties-common 
    
### Install MariaDB
MariaDB is the database management system used by ERPNext.

    sudo apt install -y libmariadb-dev mariadb-server pkg-config

### Enabling Mariadb boots 
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
    
### Secure MySQL Installation

    sudo mysql_secure_installation
    
### MySQL database development files
This installs libraries needed to develop and compile MySQL client applications, which are essential for interacting with MySQL databases.

    sudo apt install -y libmysqlclient-dev mariadb-client

### Edit the mariadb configuration ( unicode character encoding )
Open the MySQL configuration file for editing:

    sudo nano /etc/mysql/my.cnf

Add the following lines to the configuration file:
    
     [mysqld]
     character-set-client-handshake = FALSE
     character-set-server = utf8mb4
     collation-server = utf8mb4_unicode_ci

     [mysql]
     default-character-set = utf8mb4


### Restart Mariadb 

    sudo systemctl restart mariadb

### Install Redis
Redis is used for caching and background job processing.

    sudo apt install -y redis-server

### Enabling Redis boots 
    sudo systemctl enable redis.service
    sudo systemctl start redis.service

### Install Node.js 20.X package
Curl is required for downloading files and setting up Node.js.

    sudo apt install -y curl 

### Install Node.js
Use NVM (Node Version Manager) to install Node.js version 18.

    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    source ~/.profile
    nvm install 20 

### Install Npm and yarn
Install npm, the Node.js package manager.

    sudo apt install -y npm

Install Yarn, a fast and reliable JavaScript package manager.

    sudo npm install -g yarn

### Install wkhtmltopdf
These tools are used to convert HTML pages into PDF files, often for generating reports or documents.

    sudo apt install -y xvfb libfontconfig wkhtmltopdf
    
### Install frappe-bench
Quickly set up your Frappe development environment with this command:

    sudo -H pip3 install frappe-bench --break-system-packages
    bench --version 
    
### Initialize Frappe Bench with a Specific Version
Initialize Frappe Bench using version 15.

    bench init frappe-bench --frappe-branch version-15

### Switch directories into the Frappe Bench directory
    cd frappe-bench

### Set Permissions for the User Directory
Make sure the user has the correct permissions to access their home directory.

    chmod -R o+rx .
     
### Create a new site in frappe bench 

### Note 
> Warning: MariaDB version ['10.11', '7'] is more than 10.8 which is not yet tested with Frappe Framework.
Set up a new site with the following command.
    
    bench new-site asmtech.co.rw
    bench --site asmtech.co.rw add-to-hosts

### Install Standard and Custom Apps from GitHub(Optional)
> Install a Standard App
To install a standard app from the Frappe ecosystem, run:

    bench get-app erpnext --branch version-15
    bench get-app payments
    bench get-app hrms
    
### Install a Custom App from GitHub
> For a custom app hosted on GitHub, use:
bench get-app --branch [branch-name] [app-name] [github remote link]

    bench --site asmtech.co.rw install-app erpnext
    sudo -H pip3 install pillow --break-system-packages

    bench get-app https://github.com/erpchampions/uganda_compliance.git 
    bench --site asmtech.co.rw install-app uganda_compliance

    bench --site asmtech.co.rw migrate
    bench restart

    bench start

### Prepare Your Site for Production
Activate the scheduler for your site.

    bench --site asmtech.co.rw enable-scheduler

> Set Maintenance Mode off
Disable maintenance mode to make your site accessible.

     bench --site asmtech.co.rw set-maintenance-mode off

### Step 20: Set Up the Virtual Environment
Run the following command to install and configure the Python virtual environment if it hasn't been set up already.

      python3 -m venv env

### Step 21 Activate your virtual environment
      
    source env/bin/activate
    
### Step 22: Install and Configure Additional Tools
> Install Ansible (Python Package)
> Install Ansible to manage automation tasks.

    sudo /usr/bin/python3 -m pip install ansible --break-system-packages
    
### Install Fail2ban
Set up Fail2ban to enhance security.

    sudo apt install -y fail2ban
    
### Install and Configure Nginx and Supervisor
> Install Nginx
Update your package list and install Nginx.

    sudo apt update
    sudo apt install -y nginx 
    
### Install and setup Supervisor
Install Supervisor to manage processes.

    sudo apt update && sudo apt install -y supervisor 
    
### Set Up Production Environment
Finally, set up the production environment using the following command:

    sudo bench setup production frappe

> And that’s it! You’ve successfully installed ERPNext Version 15 on Ubuntu 24. Your system is now ready for use.

    
### Setup NGINX to apply the changes

    bench setup nginx

### Restart Supervisor and Launch Production Mode

    sudo supervisorctl restart all
    sudo bench setup production frappe

If you are prompted to save the new/existing config file, respond with a Y.

When this completes doing the settings, your instance is now on production mode and can be accessed using your IP, without needing to use the port.

This also will mean that your instance will start automatically even in the event you restart the server.

Default User is Administrator and use password you entered while creating new site.

Open url http://asmtech.co.rw:8000 to login 

### To setup multitenancy check out this link
- https://frappeframework.com/docs/v15/user/en/bench/guides/setup-multitenancy
- https://github.com/frappe/bench/wiki/Multitenant-Setup
