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

### STEP 1 Install ubuntu update
    sudo apt update -y && sudo apt upgrade -y

### STEP 2 Install git
    sudo apt install -y git software-properties-common

### STEP 3 install -y python-dev 
    sudo apt install -y python3-dev

### STEP 4 Install setuptools and pip (Python's Package Manager).
    sudo apt install -y python3-setuptools python3-pip 

### STEP 5 Install virtualenv
    sudo apt install -y python3-venv
    
### STEP 6 Install MariaDB
    sudo apt install -y mariadb-server
    
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
    
    sudo mysql_secure_installation
    
### STEP 7  MySQL database development files
    sudo apt install -y libmysqlclient-dev

### STEP 8 Edit the mariadb configuration ( unicode character encoding )
    sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf

add this to the 50-server.cnf file
    
     [server]
     user = mysql
     pid-file = /run/mysqld/mysqld.pid
     socket = /run/mysqld/mysqld.sock
     basedir = /usr
     datadir = /var/lib/mysql
     tmpdir = /tmp
     lc-messages-dir = /usr/share/mysql
     bind-address = 127.0.0.1
     query_cache_size = 16M
     log_error = /var/log/mysql/error.log

    [mysqld]
    innodb-file-format=barracuda
    innodb-file-per-table=1
    innodb-large-prefix=1
    character-set-client-handshake = FALSE
    character-set-server = utf8mb4
    collation-server = utf8mb4_unicode_ci      
 
    [mysql]
    default-character-set = utf8mb4

    sudo systemctl restart mariadb

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

### STEP 14 Install ufw 
    sudo apt install -y ufw
    sudo ufw enable
    sudo ufw allow 22/tcp
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw allow 8000/tcp
    sudo ufw reload
    
### STEP 15 initilise the frappe bench & install frappe latest version 
    bench init frappe-bench --frappe-branch version-15
     
### STEP 16 create a site in frappe bench 

>### Note 
>Warning: MariaDB version ['10.11', '7'] is more than 10.8 which is not yet tested with Frappe Framework.
    
    bench new-site dcode.com
    bench --site dcode.com add-to-hosts

Open url http://dcode.com:8000 to login 


### STEP 17 install ERPNext latest version in bench & site
    bench get-app erpnext --branch version-15
    bench get-app payments
    bench get-app hrms
    
    bench --site dcode.com install-app erpnext
    bench --site dcode.com install-app hrms
    bench --site dcode.com install-app payments
    
    bench start

    
