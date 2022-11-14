#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
YELOW="\e[33m"  
BLUE="\e[34m"
ENDCOLOR="\e[0m";

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo -e "${RED}!!! run as root !!!${ENDCOLOR}"
    exit
fi

handleDebian() {
    echo "installing dedicated Debian Variant"
    cd /
    cd bin
    wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Debian/D-automator
    mv D-automator automator
    chmod +x automator
    wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Debian/D-automator-update # change link when pass to release version;
    # wget https://raw.githubusercontent.com/AROA-DEV/automator/main/Dedicated/Debian/D-automator-update
    mv D-automator-update automator-update
    chmod +x automator-update
    exit
}

handleUbuntu() {
    echo "Ubuntu variant is not available"
    # echo "installing dedicated Debian Variant"
    # cd /
    # cd bin
    # 3wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Debian/D-automator
    # mv D-automator automator
    # chmod +x automator
    # wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Debian/D-automator-update # change link when pass to release version;
    # wget https://raw.githubusercontent.com/AROA-DEV/automator/main/Dedicated/Debian/D-automator-update
    # mv D-automator-update automator-update
    # chmod +x automator-update
    # exit
}

handleKali() {
    echo "installing dedicated Kali"
    cd /
    cd bin
    wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Kali/K-automator # change link when pass to release version;
    # wget https://raw.githubusercontent.com/AROA-DEV/automator/main/Dedicated/Kali/K-automator 
    mv K-automator automator
    chmod +x automator
    wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Kali/K-automator-update # change link when pass to release version;
    # wget https://raw.githubusercontent.com/AROA-DEV/automator/main/Dedicated/Kali/K-automator-update
    mv K-automator-update automator-update
    chmod +x automator-update
    exit
}

handleArch() {
    echo "installing dedicated Arch Variant"
    cd /
    cd bin
    wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Arch/Arch-automator; # change link when pass to release version;
    # wget https://raw.githubusercontent.com/AROA-DEV/automator/main/Dedicated/Arch/Arch-automator;
    mv Arch-automator automator
    chmod +x automator
    wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/Dedicated/Arch/Arch-automator-update # change link when pass to release version;
    # wget https://raw.githubusercontent.com/AROA-DEV/automator/main/Dedicated/Arch/Arch-automator-update
    mv Arch-automator-update automator-update
    chmod +x automator-update
    exit
}

handleUnknown() {
   echo "No suported OS detected some thing may not work"
}

read distro </etc/issue
case "${distro}" in
    *Debian* )   handleDebian;;
    *Ubuntu* )   handleUbuntu;;
    *Kali* )     handleKali;;
    *Arch* )     handleArch;;
    *)           handleUnkown;;
esac