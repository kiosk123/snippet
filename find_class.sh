#!/bin/sh

#-------------------------------
# $1 : directory
# $2 : class name
#-------------------------------
jars=`find $1 -name "*.jar"`

for jarfile in $jars
do
    count=`jar tvf $jarfile | grep $2 | wc -l`
    if [ $count -gt 0 ]
    then
        echo "$jarfile contains $2 class"
        break
    fi
done
