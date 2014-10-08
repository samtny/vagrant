#!/bin/bash

set -e

SEMAPHORE=./semaphore.pecl

if [ ! -f $SEMAPHORE ]; then
  sudo pecl install channel://pecl.php.net/xhprof-0.9.4
  sudo echo "extension=xhprof.so" | sudo tee /etc/php5/conf.d/xhprof.ini
  sudo echo "xhprof.output_dir=/tmp" | sudo tee /etc/php5/conf.d/xhprof.ini
  sudo service php5-fpm restart
  sudo cp -r /usr/share/php/xhprof_html /var/www/xhprof_html
  touch $SEMAPHORE
fi

exit 0

