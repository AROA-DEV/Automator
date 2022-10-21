#!/bin/bash
    /etc/os-release
    
    cat
    
    grep
    
    /etc/os-release
    
    source /etc/os-release
    
    cat /etc/issue
echo $distro
if [[ "$distro" = "Debian" ]];
then
 echo "You are using Debian"
else
 echo "you are not using Debian some things may not work"
fi
