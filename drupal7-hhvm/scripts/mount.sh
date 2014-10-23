#!/bin/bash

DIRNAME=`dirname $0`

mkdir -p $DIRNAME/../export/var/www
sudo mount -t nfs -o soft,intr,rsize=8192,wsize=8192,timeo=900,retrans=3,proto=tcp,rw 192.168.33.12:/var/www $DIRNAME/../export/var/www

exit 0

