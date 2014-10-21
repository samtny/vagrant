#!/bin/bash

set -e

SEMAPHORE=./semaphore.toku

if [ ! -f $SEMAPHORE ]; then
  CWD_OLD=$(pwd)

  sudo apt-get install -y libaio1
  sudo groupadd -g 927 mysql
  sudo useradd -r -u 927 -g mysql mysql

  sudo mkdir -pv /opt/tokutek
  cd /opt/tokutek
  sudo wget https://s3.amazonaws.com/tokudb-7.5.0/mysql-5.5.39-tokudb-7.5.0-linux-x86_64.tar.gz >/dev/null 2>&1
  sudo tar xvzf mysql-5.5.39-tokudb-7.5.0-linux-x86_64.tar.gz >/dev/null 2>&1
  sudo ln -sv mysql-5.5.39-tokudb-7.5.0-linux-x86_64 mysql

  sudo chown -R mysql:mysql /opt/tokutek/mysql

  sudo mkdir -p /etc/mysql
  sudo cp /vagrant/templates/my.cnf /etc/mysql/my.cnf
  #sudo cp /vagrant/templates/my.cnf /etc/my.cnf
  sudo ln -s /etc/mysql/my.cnf /etc/my.cnf
  
  cd /opt/tokutek/mysql
  sudo bash scripts/mysql_install_db --user=mysql

  sudo ln -sv /opt/tokutek/mysql/support-files/mysql.server /etc/init.d/mysql
  sudo chmod 755 /etc/init.d/mysql
  sudo update-rc.d mysql defaults

  sudo apt-get install -y mysql-client-core-5.5
  
  sudo service mysql start

  sleep 5
  
  mysql -u root -e "drop user ''@'localhost';"
  
  cd $CWD_OLD

  touch $SEMAPHORE
fi

exit 0

