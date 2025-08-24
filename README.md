cu# Frappe-ERPNext Version-15 in Ubuntu 24.04 LTS
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
> Ubuntu 24.04 default python version is python3.12
> Ubuntu 24.04 default mariadb version is 10.11

### STEP 1 Install ubuntu update
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y software-properties-common

### STEP 2 Install git
    sudo apt install -y git

### STEP 3 install -y python-dev 
    sudo apt install -y python3.10-dev

### STEP 4 Install setuptools and pip (Python's Package Manager).
    sudo apt install -y python3-setuptools python3.10-pip

### STEP 5 Install virtualenv
    sudo apt install -y python3.10-venv
    
### STEP 6 Install MariaDB
    sudo apt install -y mariadb-server
    
    sudo systemctl status mariadb
    sudo mysql_secure_installation
    
    
      In order to log into MariaDB to secure it, we'll need the current
      password for the root user. If you've just installed MariaDB, and
      haven't set the root password yet, you should just press enter here.

      Enter current password for root (enter for none): # PRESS ENTER
      OK, successfully used password, moving on...
      
      
      Switch to unix_socket authentication [Y/n] Y
      Enabled successfully!
      Reloading privilege tables..
       ... Success!
 
      Change the root password? [Y/n] Y
      New password: 
      Re-enter new password: 
      Password updated successfully!
      Reloading privilege tables..
       ... Success!

      Remove anonymous users? [Y/n] Y
       ... Success!
 
       Disallow root login remotely? [Y/n] Y
       ... Success!

       Remove test database and access to it? [Y/n] Y
       - Dropping test database...
       ... Success!
       - Removing privileges on test database...
       ... Success!
 
       Reload privilege tables now? [Y/n] Y
       ... Success!

    
### STEP 7  MySQL database development files
    sudo apt install -y libmysqlclient-dev

### STEP 8 Edit the mariadb configuration ( unicode character encoding )
    sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf

add this to the 50-server.cnf file

    
     [mysqld]
    character-set-server = utf8mb4
    collation-server = utf8mb4_unicode_ci
    innodb_file_format = Barracuda
    innodb_large_prefix = 1
    


Now press (Ctrl-X) to exit
    sudo service mysql restart

### STEP 9 install Redis
    sudo apt install -y redis-server

### STEP 10 install Node.js 18.X package
    sudo apt install -y curl 
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    source ~/.profile
    nvm install 18

### STEP 11  install Yarn
    sudo apt install -y npm
    sudo npm install -g yarn

### STEP 12 install wkhtmltopdf
    sudo apt install -y xvfb libfontconfig wkhtmltopdf
    
### STEP 13 install frappe-bench and Ansible 
    sudo -H pip3 install frappe-bench --break-system-packages
    sudo -H pip3 install ansible --break-system-packages
    bench --version
    
### STEP 14 initilise the frappe bench & install frappe latest version 
    bench init frappe-bench --frappe-branch version-15
    
    cd frappe-bench/
    bench start
    
### STEP 15 create a site in frappe bench 

>### Note 
>Warning: MariaDB version ['10.11', '7'] is more than 10.8 which is not yet tested with Frappe Framework.
    
    bench new-site dcode.com
    bench --site dcode.com add-to-hosts

Open url http://dcode.com:8000 to login 


### STEP 16 install ERPNext latest version in bench & site
    bench get-app erpnext --branch version-15
    bench get-app payments
    bench get-app hrms
    
    bench --site dcode.com install-app erpnext
    bench --site scode.com install-app hrms
    bench --site scode.com install-app payments
    bench start
    
    


    
