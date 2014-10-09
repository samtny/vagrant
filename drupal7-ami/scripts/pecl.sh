#!/bin/bash

set -e

SEMAPHORE=./semaphore.pecl

if [ ! -f $SEMAPHORE ]; then
  sudo pecl install channel://pecl.php.net/xhprof-0.9.4
  sudo echo "extension=xhprof.so" | sudo tee /etc/php5/conf.d/xhprof.ini
  sudo echo "xhprof.output_dir=/tmp" | sudo tee -a /etc/php5/conf.d/xhprof.ini
  sudo service php5-fpm restart
  sudo cp -r /usr/share/php/xhprof_html /var/www/xhprof_html
  touch $SEMAPHORE
fi

SEMAPHORE=./semaphore.igbinary

if [ ! -f $SEMAPHORE ]; then
  sudo pecl install channel://pecl.php.net/igbinary-1.2.1
  sudo echo "extension=igbinary.so" | sudo tee /etc/php5/conf.d/igbinary.ini
  sudo echo "session.serialize_handler=igbinary" | sudo tee -a /etc/php5/conf.d/igbinary.ini
  sudo service php5-fpm restart
  touch $SEMAPHORE
fi

SEMAPHORE=./semaphore.runkit

if [ ! -f $SEMAPHORE ]; then
  sudo pecl install https://github.com/downloads/zenovich/runkit/runkit-1.0.3.tgz
  sudo echo "extension=runkit.so" | sudo tee /etc/php5/conf.d/runkit.ini
  sudo service php5-fpm restart
  touch $SEMAPHORE
fi

exit 0

