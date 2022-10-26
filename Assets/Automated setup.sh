#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
YELOW="\e[33m"  
BLUE="\e[34m"
ENDCOLOR="\e[0m";

handleDebian() {
    echo "instaling dedicated Debian Variant"
    cd /
    cd bin
    wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Debian/D-automator
    mv D-automator automator
    chmod +x automator
    wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Debian/D-automator-update; # change link when pass to release version;
    # wget https://raw.githubusercontent.com/AROA-DEV/automator/main/Dedicated/Debian/D-automator-update;
    mv D-automator-update automator-update;
    chmod +x automator-update;
}

handleUbuntu() {
    echo "Using Ubuntu"
}

handleKali() {
    echo "Using Kali"
}

handleArch() {
    echo "instalinh dedicated Arch Variant"
    cd /
    cd bin
    wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Arch/Arch-automator
    mv Arch-automator automator
    chmod +x automator
}

handleUnknown() {
   echo "No suported OS detected some thing may not work"
}

read distro </etc/issue
case "${distro}" in
    *Debian* )   handleDebian;;
    *Ubuntu* )   handleUbuntu;;
    *kali* )     handleKali;;
    *Arch* )     handleArch;;
    *)           handleUnkown;;
esac