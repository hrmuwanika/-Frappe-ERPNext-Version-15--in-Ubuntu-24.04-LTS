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
> Ubuntu 24.04 default python version is python3.12 and mariadb default version is 10.11

### STEP 1 Update and Upgrade Packages
    sudo apt update -y && sudo apt upgrade -y

### STEP 2 Create a new user – (bench user)
    sudo adduser frappe
    sudo usermod -aG sudo frappe
    su - frappe
    cd /home/frappe
    
### STEP 3 Install git
    sudo apt install -y git

### STEP 4 install -y python-dev 
    sudo apt install -y python3-dev

### STEP 5 Install setuptools and pip (Python's Package Manager).
    sudo apt install -y python3-setuptools python3-pip 

### STEP 6 Install virtualenv
    sudo apt install -y python3.12-venv
    
### STEP 7 Install MariaDB
    sudo apt install -y software-properties-common libmariadb-dev mariadb-server mariadb-client pkg-config
    
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
    
    sudo mariadb-secure-installation
    
### STEP 8  MySQL database development files
    sudo apt install -y libmysqlclient-dev

### STEP 9 Edit the mariadb configuration ( unicode character encoding )
    sudo nano /etc/mysql/my.cnf


add this to the 50-server.cnf file
    
     [mysqld]
     character-set-client-handshake = FALSE
     character-set-server = utf8mb4
     collation-server = utf8mb4_unicode_ci

     [mysql]
     default-character-set = utf8mb4


    sudo systemctl restart mariadb

### STEP 10 install Redis
    sudo apt install -y redis-server
    sudo systemctl enable redis-server.service
    sudo systemctl start redis-server.service

### STEP 11 install Node.js 18.X package
    sudo apt install -y curl 
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    source ~/.profile
    nvm install 18 

### STEP 12  install Yarn
    sudo apt install -y npm
    sudo npm install -g yarn

### STEP 13 install wkhtmltopdf
    sudo apt install -y xvfb libfontconfig wkhtmltopdf
    
### STEP 14 install frappe-bench
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
    
### STEP 16 Initialize Frappe Bench 
    bench init frappe-bench --frappe-branch version-15

### Switch directories into the Frappe Bench directory
    cd frappe-bench

### Change user directory permissions
    chmod -R o+rx /home/frappe
     
### STEP 17 create a new site in frappe bench 

>### Note 
>Warning: MariaDB version ['10.11', '7'] is more than 10.8 which is not yet tested with Frappe Framework.
    
    bench new-site dcode.com
    bench --site dcode.com add-to-hosts

Open url http://dcode.com:8000 to login 


### STEP 18 Download all the apps we want to install
    bench get-app erpnext --branch version-15
    bench get-app payments
    bench get-app hrms
    
    bench --site dcode.com install-app erpnext
    bench --site dcode.com install-app ugandan_compliance
    
    bench start

    
