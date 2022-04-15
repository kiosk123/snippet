#!/bin/bash

MOUNT_DIR=$1
if [ -z "$MOUNT_DIR" ] ; then
	echo "mount.sh <mount directory>"
	exit 1
fi 

# make mount directory
if [ ! -d "$MOUNT_DIR" ] ; then
   mkdir -p "$MOUNT_DIR"
fi

# check mount status and mount
if [ `sudo fdisk -l | grep '/dev/sd[a-z][0-9]' | awk '{print $1}' | wc -l` -gt 0 ] ; then
    TMP_DIR=`df -h | grep '/dev/sd[a-z][0-9]' | awk '{print $6}'`
    if [  "$TMP_DIR" != "$MOUNT_DIR" ] ; then
    	if [ `df -h | grep '/dev/sd[a-z][0-9]' | awk '{print $6}' | wc -l` -gt 0 ] ; then
            sudo umount `sudo fdisk -l | grep '/dev/sd[a-z][0-9]' | awk '{print $1}'`
        fi
        sudo mount `sudo fdisk -l | grep '/dev/sd[a-z][0-9]' | awk '{print $1}'` "$MOUNT_DIR" -o rw,umask=0000
    fi
    exit 0
else
	exit 1
fi
