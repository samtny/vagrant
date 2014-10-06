#!/bin/bash

SEMAPHORE=/vagrant/data/semaphore

if [ ! -f $SEMAPHORE ]; then
  sudo apt-get update
  touch $SEMAPHORE
fi

exit 0

