#!/bin/bash

set -e

SEMAPHORE=./semaphore.bootstrap

if [ ! -f $SEMAPHORE ]; then
  sudo apt-get install -y python-software-properties
  sudo apt-add-repository -y ppa:nginx/stable

  sudo apt-get update

  touch $SEMAPHORE
fi

exit 0

