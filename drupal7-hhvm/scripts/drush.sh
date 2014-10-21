#!/bin/bash

set -e

SEMAPHORE=./semaphore.drush

if [ ! -f $SEMAPHORE ]; then
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer

  sed -i '1i export PATH="$HOME/.composer/vendor/bin:$PATH"' /etc/profile
  source /etc/profile

  composer global require drush/drush:6.*

  touch $SEMAPHORE
fi

exit 0

