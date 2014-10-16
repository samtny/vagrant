#!/bin/bash

set -e

SEMAPHORE=./semaphore.phpMemcachedAdmin

if [ ! -f $SEMAPHORE ]; then
  sudo cp -r /vagrant/templates/phpMemcachedAdmin /var/www
  sudo chown -R vagrant:www-data /var/www/phpMemcachedAdmin
  sudo chmod -R 2775 /var/www/phpMemcachedAdmin

  touch $SEMAPHORE
fi

exit 0

