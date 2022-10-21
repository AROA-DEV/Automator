#!/bin/bash
cat /etc/issue read distro 
read distro   
echo $distro
if [[ "$distro" = "Debian GNU/Linux bookworm/sid \n \l" ]];
then
 echo "You are using Debian"
else
 echo "you are not using Debian some things may not work"
fi
