#!/bin/bash

set -e

SEMAPHORE=./semaphore.xhprof_html

if [ ! -f $SEMAPHORE ]; then
  sudo mkdir -p /usr/share/php
  sudo cp -r /vagrant/templates/xhprof_html /usr/share/php
  sudo chown -R vagrant:www-data /usr/share/php/xhprof_html
  sudo chmod -R 2775 /usr/share/php/xhprof_html

  touch $SEMAPHORE
fi

exit 0

