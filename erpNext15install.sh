#!/bin/bash

 timedatectl set-timezone "Africa/Kampala"

read -rsp "Please enter sudo password:" passwrd
echo -e "\n"
read -rsp "Please enter mysql root password:" sql_passwrd
echo -e "\n\n"

#read -p "Let's Update the system first. Please hit Enter to start..."

echo $passwrd | sudo -S apt update -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt upgrade -y

#read -p "Now, we'll install some prerequisites. Please hit Enter to start..."

echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install nano git curl -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install python3-dev python3-pip python3-setuptools -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install python3-venv -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install cron software-properties-common mariadb-client mariadb-server libmysqlclient-dev -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install supervisor redis-server xvfb libfontconfig wkhtmltopdf -y
MARKER_FILE=~/.MariaDB_handled.marker

echo $passwrd | sudo -S systemctl enable mariadb
echo $passwrd | sudo -S systemctl start mariadb

if [ ! -f "$MARKER_FILE" ]; then
 #read -p "Let's configure your Mariadb server. Please hit Enter to start..."
 echo $passwrd | sudo -S mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$sql_passwrd';"
 echo $passwrd | sudo -S mysql -u root -p"$sql_passwrd" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$sql_passwrd';"
 echo $passwrd | sudo -S mysql -u root -p"$sql_passwrd" -e "DELETE FROM mysql.user WHERE User='';"
 echo $passwrd | sudo -S mysql -u root -p"$sql_passwrd" -e "DROP DATABASE IF EXISTS test;DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
 echo $passwrd | sudo -S mysql -u root -p"$sql_passwrd" -e "FLUSH PRIVILEGES;"
 
 echo $passwrd | sudo -S bash -c 'cat << EOF >> /etc/mysql/my.cnf
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
EOF'

 echo $passwrd | sudo -S systemctl restart mariadb
 touch "$MARKER_FILE"
fi

#read -p "Next, we'll install Node, NPM and Yarn. Please hit Enter..."
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install 18

echo $passwrd | sudo -S NEEDRESTART_MODE=a apt install npm -y
echo $passwrd | sudo -S npm install -g yarn

#read -p "well, now we are ready to install frappe. Ready? :-) Hit Enter..."

echo $passwrd | sudo -S pip3 install frappe-bench --break-system-packages
echo $passwrd | sudo -S pip3 install ansible --break-system-packages

bench init --frappe-branch version-15 frappe-bench

chmod -R o+rx .

cd frappe-bench/

read -p "Frappe is initialized. Would you like to continue to create a site? (Y/n) " ans
if [ $ans = "n" ]; then exit 0; fi 
ans=""
read -p "Please enter new site name: " newSite
bench new-site $newSite --db-root-password $sql_passwrd
bench use $newSite
echo -e "If you wish to install a custom apps, enter it's URIs.\nStarting with the first:\n"
while read URI; do
 if [ "$URI" = "" ]; then
 break
 fi
 
 IFS='/' read -a array <<< "$URI"
 bench get-app --resolve-deps $URI
 app_name=${array[-1]}
 if [[ $app_name == *".git" ]]; then
 bench install-app "${app_name:0:-4}";
 else 
 bench install-app "${app_name}";
 fi
 
 URI=""
 echo -e "Any more apps? Enter another URI (otherwise hit Enter):\n"
done
read -p "Would you like to continue and install ERPNext? (y/N) " ans
if [ $ans = "y" ]; then 
  ans=""
  bench get-app payments
  bench get-app --branch version-15 erpnext
  bench get-app hrms
  bench install-app erpnext
  bench install-app hrms
fi

read -p "Good! Now, is your server ment for production? (Y/n) " ans
if [ $ans = "n" ]; then exit 0; fi 
ans=""
echo $passwrd | sudo -S sed -i -e 's/include:/include_tasks:/g' /usr/local/lib/python3.12/dist-packages/bench/playbooks/roles/mariadb/tasks/main.yml
yes | sudo bench setup production $USER
FILE="/etc/supervisor/supervisord.conf"
SEARCH_PATTERN="chown=$USER:$USER"
if grep -q "$SEARCH_PATTERN" "$FILE"; then
 echo $passwrd | sudo -S sed -i "/chown=.*/c $SEARCH_PATTERN" "$FILE"
else
 echo $passwrd | sudo -S sed -i "5a $SEARCH_PATTERN" "$FILE"
fi

echo $passwrd | sudo -S service supervisor restart
yes | sudo bench setup production $USER

bench --site $newSite scheduler enable
bench --site $newSite scheduler resume

bench setup socketio
yes | bench setup supervisor
bench setup redis
echo $passwrd | sudo -S supervisorctl reload

sudo apt install -y ufw
sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8000/tcp
sudo ufw reload

read -p "You can now configure SSL with a custom domain. Would you like to do so? (Y/n) " ans
if [ $ans = "n" ]; then exit 0; fi 
echo "First, make sure that there is an A record on your domain DNS pointing to the ERPNext server's IP address."
read -p "Then press enter to continue..."

bench config dns_multitenant on

read -p "Please enter your ERPNext server FQDN: " fqdn
bench setup add-domain $fqdn --site $newSite

bench setup nginx 

sudo service nginx reload

sudo snap install core
sudo snap refresh core

sudo snap install --classic certbot

sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo certbot --nginx



