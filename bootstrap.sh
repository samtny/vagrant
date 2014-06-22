#!/bin/bash

if [ ! -f /home/vagrant/shell-provisioner-done ]; then
  #sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8D0DC64F
  sudo apt-get install -y python-software-properties
  sudo apt-add-repository ppa:l-mierzwa/lucid-php5
  apt-get update
  touch /home/vagrant/shell-provisioner-done
fi
