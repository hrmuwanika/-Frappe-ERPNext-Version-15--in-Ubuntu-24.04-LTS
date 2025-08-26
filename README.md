Frappe-ERPNext Version-15 in Ubuntu 24.04 LTS
A complete Guide to Install Frappe/ERPNext version 15  in Ubuntu 24.04 LTS


#### Refer this for default python 3.11 setup

- [D-codeE Video Tutorial](https://youtu.be/zU41gq7nji4)

### Pre-requisites 

      Python 3.11+                                  (python 3.12 is inbuilt in Ubuntu 24.04 LTS)
      Node.js 18+
      
      Redis 5                                       (caching and real time updates)
      MariaDB 10.3.x / Postgres 9.5.x               (to run database driven apps)
      yarn 1.12+                                    (js dependency manager)
      pip 20+                                       (py dependency manager)
      wkhtmltopdf (version 0.12.5 with patched qt)  (for pdf generation)
      cron                                          (bench's scheduled jobs: automated certificate renewal, scheduled backups)
      NGINX                                         (proxying multitenant sites in production)


> ## Note:
> ubuntu 24.04 default python version is python3.12
> 
> ubuntu 24.04 default mariadb version is 10.11

### STEP 1 Update and Upgrade Packages
> First, update your package list and upgrade your installed packages to ensure you’re starting with the latest versions.

    sudo apt update -y && sudo apt upgrade -y
    sudo reboot

### STEP 2 Create a new user – (Frappe Bench User)
> create a new user for running the Frappe Bench.

    sudo adduser frappe
    sudo usermod -aG sudo frappe
    su - frappe
    cd /home/frappe
    
### STEP 3 Install git
> Git is required for version control and to clone repositories.

    sudo apt install -y git

### STEP 4 install -y python-dev 
> Install Python 3.12 and its development tools.

    sudo apt install -y python3-dev python3.12-dev

### STEP 5 Install setuptools and pip (Python's Package Manager).

    sudo apt install -y python3-setuptools python3-pip 

### STEP 6 Install virtualenv
> Set up a virtual environment for Python 3.12.
 
    sudo apt install -y python3.12-venv
    
### STEP 7 Install MariaDB
> MariaDB is the database management system used by ERPNext.

    sudo apt install -y software-properties-common 
    sudo apt install -y libmariadb-dev mariadb-server mariadb-client pkg-config

### ### Enabling Mariadb boots 
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
    
### Secure MySQL Installation

    sudo mariadb-secure-installation
    
### STEP 8  MySQL database development files
> This installs libraries needed to develop and compile MySQL client applications, which are essential for interacting with MySQL databases.

    sudo apt install -y libmysqlclient-dev

### STEP 9 Edit the mariadb configuration ( unicode character encoding )
> Open the MySQL configuration file for editing:

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

### STEP 10 install Redis
> Redis is used for caching and background job processing.

    sudo apt install -y redis-server

### STEP 11 install Node.js 18.X package
> Curl is required for downloading files and setting up Node.js.

    sudo apt install -y curl 

### Install Node.js
> Use NVM (Node Version Manager) to install Node.js version 18.

    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    source ~/.profile
    nvm install 18 

### STEP 12  install Npm and yarn
> Install npm, the Node.js package manager.

    sudo apt install -y npm

> Install Yarn, a fast and reliable JavaScript package manager.

    sudo npm install -g yarn

### STEP 13 install wkhtmltopdf
> These tools are used to convert HTML pages into PDF files, often for generating reports or documents.

    sudo apt install -y xvfb libfontconfig wkhtmltopdf
    
### STEP 14 install frappe-bench
> Quickly set up your Frappe development environment with this command:

    sudo -H pip3 install frappe-bench --break-system-packages
    bench --version 

### Install ansible
    sudo -H pip3 install ansible --break-system-packages

### STEP 15 Install ufw 
    sudo apt install -y ufw
    sudo ufw enable
    sudo ufw allow 22/tcp
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw allow 8000/tcp
    sudo ufw reload
    
### STEP 16 Initialize Frappe Bench with a Specific Version
> Initialize Frappe Bench using version 15.

    bench init frappe-bench --frappe-branch version-15

### Switch directories into the Frappe Bench directory
    cd frappe-bench

### Set Permissions for the User Directory
> Make sure the user has the correct permissions to access their home directory.

    chmod -R o+rx /home/frappe
     
### STEP 17 create a new site in frappe bench 

>### Note 
> Warning: MariaDB version ['10.11', '7'] is more than 10.8 which is not yet tested with Frappe Framework.
> Set up a new site with the following command.
    
    bench new-site dcode.com
    bench --site dcode.com add-to-hosts

Open url http://dcode.com:8000 to login 


### STEP 18 Download all the apps we want to install
> Add and install ERPNext version 15 on your new site.

    bench get-app erpnext --branch version-15
    bench get-app payments
    bench get-app hrms
    
    bench --site dcode.com install-app erpnext
    pip install pillow --break-system-packages

    bench get-app https://github.com/erpchampions/uganda_compliance.git 
    bench --site asmtech.co.rw install-app uganda_compliance
    bench --site asmtech.co.rw migrate
    bench restart
    
    bench start

    
