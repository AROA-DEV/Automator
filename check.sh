#!/bin/bash
cat /etc/issue
read distro
if [[ "$distro" -eq "Debian" ]];
then
 echo "You are using Debian"
else
 echo "you are not using Debian some things may not work"
fi
