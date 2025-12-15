#!/bin/bash

IP=192.168.0.13

while [ 1 ] ; do
  netstat -ant | grep "$IP"
  CNT=`netstat -ant | grep "$IP" | wc -l`
  echo "CONNECTION COUNT : ${CNT}"
  sleep 1
  clear

done
