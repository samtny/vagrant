#!/bin/bash

set -e

SEMAPHORE=./semaphore.bootstrap

if [ ! -f $SEMAPHORE ]; then
  sudo apt-get update
  
  touch $SEMAPHORE
fi

exit 0
