#!/bin/bash

set -e

SEMAPHORE=./semaphore.hhvm

if [ ! -f $SEMAPHORE ]; then
  sudo add-apt-repository ppa:mapnik/boost
  wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
  echo deb http://dl.hhvm.com/ubuntu precise main | sudo tee /etc/apt/sources.list.d/hhvm.list
  sudo apt-get update
  sudo apt-get install -y hhvm

  sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60

  touch $SEMAPHORE
fi

exit 0

