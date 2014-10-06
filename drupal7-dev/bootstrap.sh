#!/bin/bash

SEMAPHORE_DIR=/vagrant/data
SEMAPHORE=$SEMAPHOR_DIR/semaphore

mkdir -p $SEMAPHORE_DIR

if [ ! -f $SEMAPHORE ]; then
  sudo apt-get update
  touch $SEMAPHORE
fi

exit 0

