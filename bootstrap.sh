#!/bin/bash

if [ ! -f /home/vagrant/shell-provisioner-done ]; then
  sudo apt-get install -y python-software-properties

  # percona mysql
  sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
  sudo apt-add-repository "deb http://repo.percona.com/apt lucid main"  
  sudo apt-add-repository "deb-src http://repo.percona.com/apt lucid main"

  # php5-fpm
  #sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8D0DC64F
  sudo apt-add-repository ppa:l-mierzwa/lucid-php5

  apt-get update

  touch /home/vagrant/shell-provisioner-done
fi
