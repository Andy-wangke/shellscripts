#!/bin/bash
# From here: http://www.codingsteps.com/install-redis-2-6-on-amazon-ec2-linux-ami-or-centos/
# Based on: https://github.com/saxenap/install-redis-amazon-linux-centos
# Thanks to https://raw.github.com/gist/2776679/b4f5f5ff85bddfa9e07664de4e8ccf0e115e7b83/install-redis.sh
# Uses redis-server init script from https://raw.github.com/saxenap/install-redis-amazon-linux-centos/master/redis-server
###############################################
# To use: 
## wget https://raw.github.com/jorgerc/install-redis-amazon-linux-centos/master/redis-install-script.sh
## chmod 777 redis-install-script.sh
## ./redis-install-script.sh
###############################################
echo "*****************************************"
echo " 1. Prerequisites: Install updates, set time zones, install GCC and make(for RPM)"
echo "*****************************************"
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
yum -q -y install gcc gcc-c++ make 

echo "*****************************************"
echo "for debian"
echo "apt-get update"
echo "apt-get install -y curl build-essential tcl"
echo "*****************************************"

echo "*****************************************"
echo " 2. Download, Untar and Make Redis "
echo "*****************************************"
wget -q http://download.redis.io/releases/redis-4.0.6.tar.gz
tar xzf redis-4.0.6.tar.gz
rm -f redis-4.0.6.tar.gz
cd redis-4.0.6
make -s
sudo make -s install

echo "*****************************************"
echo "3. Create Directories and copy Redis Files"
echo "*****************************************"
rm -rf /etc/redis /var/lib/redis
mkdir /etc/redis /var/lib/redis
cp src/redis-server src/redis-cli /usr/local/bin
cp redis.conf /etc/redis
echo "*****************************************"
echo " 4. Configure Redis.Conf"
echo "*****************************************"
echo " Edit redis.conf as follows:"
echo " 1: ... daemonize yes"
echo " 2: ... bind 127.0.0.1"
echo " 3: ... dir /var/lib/redis"
echo " 4: ... loglevel notice"
echo " 5: ... logfile /var/log/redis.log"
echo "*****************************************"
sed -e "s/^daemonize no$/daemonize yes/" -e "s/^# bind 127.0.0.1$/bind 127.0.0.1/" -e "s/^dir \.\//dir \/var\/lib\/redis\//" -e "s/^loglevel verbose$/loglevel notice/" -e "s/^logfile stdout$/logfile \/var\/log\/redis.log/" redis.conf > /etc/redis/redis.conf

echo "*****************************************"
echo " 5. Download init Script for running Redis"
echo "*****************************************"
cd ..
wget -q https://raw.github.com/jorgerc/install-redis-amazon-linux-centos/master/redis-server
echo "*****************************************"
echo " 6. Move and Configure Redis-Server"
echo "*****************************************"
mv redis-server /etc/init.d
chmod 755 /etc/init.d/redis-server

echo "*****************************************"
echo " 7. Auto-Enable Redis-Server"
echo "*****************************************"
chkconfig --add redis-server
chkconfig --level 345 redis-server on

echo "*****************************************"
echo " 8. Start Redis Server(uncomment while need start service)"
echo "*****************************************"
####
#service redis-server start
####

echo "*****************************************"
echo " Installation Complete!"
echo " You can test your redis installation using the redis console:"
echo "   $ src/redis-cli"
echo "   redis> ping"
echo "   PONG"
echo "*****************************************"