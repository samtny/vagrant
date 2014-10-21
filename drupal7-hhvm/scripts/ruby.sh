#!/bin/bash

set -e

SEMAPHORE=./semaphore.ruby

if [ ! -f $SEMAPHORE ]; then
  sudo apt-get install -y rubygems
  sudo gem install compass
  
  touch $SEMAPHORE
fi

exit 0

