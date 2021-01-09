#!/bin/bash

PARAM=$1
if [ "$PARAM" == "image" ] ; then
	if [ $(docker images | awk '{print $3}' | sed -n "2, \$p" | wc -l) -gt 0 ] ; then
		echo "remove image"
		docker rmi -f $(docker images | awk '{print $3}' | sed -n "2, \$p")
	else
		echo "no image to remove"
	fi
else
	echo "remove container"
	docker rm -f $(docker ps -q -a) 2>>/dev/null
fi