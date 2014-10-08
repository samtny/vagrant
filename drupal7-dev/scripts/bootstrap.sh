#!/bin/bash

SEMAPHORE=./semaphore

if [ ! -f $SEMAPHORE ]; then
  sudo apt-get update
  touch $SEMAPHORE
fi

exit 0

