#!/bin/bash

set -e

SEMAPHORE=./semaphore.xhprof_lib

if [ ! -f $SEMAPHORE ]; then
  sudo mkdir -p /usr/share/php
  sudo cp -r /vagrant/templates/xhprof_lib /usr/share/php
  sudo chown -R vagrant:www-data /usr/share/php/xhprof_lib
  sudo chmod -R 2775 /usr/share/php/xhprof_lib

  touch $SEMAPHORE
fi

exit 0

