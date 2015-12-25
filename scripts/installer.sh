HOSTNAME=$1

########## Config ##########
echo ">>>>>>>>>> Config timezone..."
sudo rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
echo ">>>>>>>>>> Config bash..."
cp /vagrant/conf/.bash* /home/vagrant/
sudo cp /vagrant/conf/.bash* /root/

########## Additional repositories ##########
echo ">>>>>>>>>> Adding Percona repo..."
sudo wget https://repo.percona.com/apt/percona-release_0.1-3.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_0.1-3.$(lsb_release -sc)_all.deb

echo ">>>>>>>>>> Adding PHP repo..."
sudo apt-get install -y python-software-properties
# 5.5
sudo add-apt-repository -y ppa:ondrej/php5-5.5
# 5.6
# sudo add-apt-repository -y ppa:ondrej/php5-5.6

sudo apt-get update


########## Web ##########
echo ">>>>>>>>>> Installing Apache..."
sudo apt-get install -y apache2 apache2-utils
sudo a2enmod rewrite
# echo ">>>>>>>>>> Installing nginx..."
# sudo apt-get install -y nginx php5-fpm

echo ">>>>>>>>>> Installing PHP..."
sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php5-gd php5-curl php5-mysql php5-xdebug
sudo cp /vagrant/conf/xdebug.ini /etc/php5/mods-available/
sudo cp /vagrant/conf/xdebug_cli.ini /etc/php5/cli/conf.d/30-xdebug_cli.ini

echo ">>>>>>>>>> Update vhost..."
sudo cp /vagrant/conf/vhost.conf "/etc/apache2/sites-available/$HOSTNAME.conf"
sudo sed -i "s/{{HOSTNAME}}/$HOSTNAME/g" "/etc/apache2/sites-available/$HOSTNAME.conf"
sudo a2ensite "$HOSTNAME"
sudo a2dissite 000-default
sudo service apache2 restart

echo ">>>>>>>>>> Installing Redis..."
sudo apt-get install -y redis-server


########## Database ##########
echo ">>>>>>>>>> Installing Percona..."
export DEBIAN_FRONTEND=noninteractive
echo 'percona-server-server-5.5     percona-server-server/root_password         password root' | sudo debconf-set-selections
echo 'percona-server-server-5.5     percona-server-server/root_password_again   password root' | sudo debconf-set-selections
sudo apt-get install -y percona-server-server-5.5 percona-server-client-5.5
sudo cp /vagrant/conf/custom.cnf /etc/mysql/conf.d/
sudo service mysql restart

echo ">>>>>>>>>> Config database user..."
mysql -uroot -proot -e "grant all on *.* to root@'192.168.%' identified by 'root';"


########## Tools ##########
# n98-magerun
sudo cp /vagrant/tools/n98-magerun.*.phar /usr/local/bin/mag
sudo chmod +x /usr/local/bin/mag

# PHPUnit
sudo cp /vagrant/tools/phpunit.*.phar /usr/local/bin/phpunit
sudo chmod +x /usr/local/bin/phpunit

# wetty:
echo ">>>>>>>>>> Installing wetty..."
sudo apt-get install -y npm nodejs-legacy
cp -r /vagrant/tools/wetty /home/vagrant/
echo "Copied to /home/vagrant folder."
cd /home/vagrant/wetty/
npm install
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
sudo cp /home/vagrant/wetty/bin/wetty.conf /etc/init/
sudo start wetty