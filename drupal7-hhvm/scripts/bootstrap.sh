#!/bin/bash

set -e

SEMAPHORE=./semaphore.bootstrap

if [ ! -f $SEMAPHORE ]; then
  sudo apt-get update

  sudo apt-get install -y python-software-properties
  sudo apt-add-repository -y ppa:nginx/stable

  wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
  echo deb http://dl.hhvm.com/ubuntu precise main | sudo tee /etc/apt/sources.list.d/hhvm.list
   
  sudo apt-get update

  touch $SEMAPHORE
fi

exit 0

