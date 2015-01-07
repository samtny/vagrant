#!/bin/bash

set -e

SEMAPHORE=./semaphore.bootstrap

if [ ! -f $SEMAPHORE ]; then
  sudo apt-get update

  sed -i '17s/.*/Prompt=never/' /etc/update-manager/release-upgrades
  rm -rf /var/lib/update-notifier/release-upgrade-available

  touch $SEMAPHORE
fi

exit 0
