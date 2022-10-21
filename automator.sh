#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELOW="\e[33m"  
BLUE="\e[34m"
ENDCOLOR="\e[0m";
echo 
echo 
echo _█████╗_██╗___██╗████████╗_██████╗_███╗___███╗_█████╗_████████╗_██████╗_██████╗ 
echo ██╔══██╗██║___██║╚══██╔══╝██╔═══██╗████╗_████║██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
echo ███████║██║___██║___██║___██║___██║██╔████╔██║███████║___██║___██║___██║██████╔╝
echo ██╔══██║██║___██║___██║___██║___██║██║╚██╔╝██║██╔══██║___██║___██║___██║██╔══██╗
echo ██║__██║╚██████╔╝___██║___╚██████╔╝██║_╚═╝_██║██║__██║___██║___╚██████╔╝██║__██║
echo ╚═╝__╚═╝ ╚═════╝____╚═╝____╚═════╝ ╚═╝_____╚═╝╚═╝__╚═╝___╚═╝____╚═════╝_╚═╝__╚═╝
echo 
uptime
who
echo
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo -e "${RED}!!! run as root !!!${ENDCOLOR}"
    echo -e "${RED} or a user with the permissions ${ENDCOLOR}"
    sleep 5
fi
echo 
cat /etc/issue #check distro
echo
echo
echo -e complete system setup "${YELOW}[systemsetup]${ENDCOLOR}"
echo -e system tools "${YELOW}[system]${ENDCOLOR}"
echo -e update "${YELOW}[update]${ENDCOLOR}"
echo -e install Osint tools "${YELOW}[1]${ENDCOLOR}"
echo -e install Exploit tools "${YELOW}[2]${ENDCOLOR}"
echo -e install Wireless tools "${YELOW}[3]${ENDCOLOR}"
echo -e install vulnerability detection tools "${YELOW}[4]${ENDCOLOR}"
echo -e show options "${YELOW}[op]${ENDCOLOR}"
echo -e show version "${YELOW}[v]${ENDCOLOR}"
echo 
while true; do
read -p "how do you want to proceed? " yn

case $yn in 

# show system options

# simple options output

    system ) echo ;
             echo system tools ;
             echo ;
             echo -e show system info "${YELOW}[sinfo]${ENDCOLOR}";
             echo ;
             echo -e test network "${YELOW}[network]${ENDCOLOR}";
             echo -e user settings "${YELOW}[user]${ENDCOLOR}";
             echo -e Remote access to the system "${YELOW}[remote]${ENDCOLOR}";
             echo ;;

    user ) echo ;
           echo -e new user "${YELOW}[newuser]${ENDCOLOR}";
           echo -e remuve user "${YELOW}[remuveuser]${ENDCOLOR}";
           echo ;;

    network ) echo ;
              echo -e show ip "${YELOW}[ip]${ENDCOLOR}";
              echo -e ping google.com "${YELOW}[ping]${ENDCOLOR}";
              echo ;;

    power ) echo ;
            echo -e reboot "${YELOW}[sreboot]${ENDCOLOR}";
            echo -e shutdown "${YELOW}[sshutdown]${ENDCOLOR}";
            echo ;;

    remote ) echo ;
             echo -e openssh-server "${YELOW}[sshserver]${ENDCOLOR}";
             echo -e xrdp "${YELOW}[xrdp]${ENDCOLOR}";
             echo ;;

    1 ) echo ;
        echo Remember some of the packets will be installed on the active directory;
        echo installing in:;
        pwd ;
        echo ;
        echo -e Osintgram  "${YELOW} [1001]${ENDCOLOR}";
        echo -e Recon-ng   "${YELOW} [1002]${ENDCOLOR}";
        echo -e infoga "${YELOW} [1003]${ENDCOLOR}";        
        echo -e phoneinfoga "${YELOW} [1004]${ENDCOLOR}";
        echo -e nmap      "${YELOW} [1005]${ENDCOLOR}";
        echo -e Profil3r   "${YELOW} [1006]${ENDCOLOR}";
        echo ;;

    2 ) echo ;
        echo Remember some of the packets will be installed on the active directory;
        echo installing in:;
        pwd ;
        echo ;
        echo -e metasploit "${YELOW} [2001]${ENDCOLOR}";
        echo -e setoolkit "${YELOW} [2002]${ENDCOLOR}";
        echo -e metasploit "${YELOW} [2003]${ENDCOLOR}";
        echo -e SocialSploit "${YELOW} [2004]${ENDCOLOR}";
        echo -e Havoc Client "${YELOW} [2005]${ENDCOLOR}";
        echo -e Havoc Team server "${YELOW} [2006]${ENDCOLOR}";
        echo ;;

    3 ) echo ;
        echo Remember some of the pakets will be installed onthe active directory;
        echo instaling in:;
        pwd ;
        echo ;
        echo -e Wifite     "${color} [3001]${ENDCOLOR}";
        echo ;;
    
    4 ) echo ;
        echo Remember some of the packets will be installed on the active directory;
        echo installing in:;
        pwd ;
        echo ;
        echo -e lynis     "${color} [4001]${ENDCOLOR}";
        echo ;;

# office tools

    0001 ) sudo apt install p7zip-full;;
    

# OSINT options

    1001 ) git clone https://github.com/AROA-DEV/Osintgram.git;
           cd Osintgram;
           pip3 install -r requirements.txt;
           wget https://github.com/AROA-DEV/Tool-Instructions/blob/main/Osintgram/usage.txt; 
           cd .. ;;

    1002 ) git clone https://github.com/lanmaster53/recon-ng.git ;;

    1003 ) git clone https://github.com/m4ll0k/Infoga.git;
           cd Infoga;
           python3 setup.py install;
           python3 infoga.py;;

    1004 ) mkdir Phoneinfoga ;
           cd PhoneInfoga ;
           wget https://github.com/AROA-DEV/Tool-Instructions/blob/main/phoneinfoga/usage.txt ;
           curl -sSL https://raw.githubusercontent.com/sundowndev/phoneinfoga/master/support/scripts/install | bash ;
           ./phoneinfoga version ;
           cd ..;;
        
    1005 ) apt update -y && apt upgrade -y;
           apt install nmap;
           apt upgrade -y;
           echo run "${YELOW}[ setoolkit ]${ENDCOLOR}";;

    1006 ) pip3 install PyInquirer jinja2 bs4;
           git clone https://github.com/amitrajputfff/Profil3r.git;
           cd Profil3r/;
           python3 setup.py install;;


# Exploit 

    2001 ) curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \ ;
           chmod 755 msfinstall && \ ;
           ./msfinstall;;

    2002 ) mkdir SEToolkit;
           cd SEToolkit;
           git clone https://github.com/trustedsec/social-engineer-toolkit setoolkit/;
           cd setoolkit;
           pip3 install -r requirements.txt;
           python setup.py;
           echo run "${YELOW}[ setoolkit ]${ENDCOLOR}";;

    2003 ) sudo apt update;
           sudo apt install curl wget gnupg2;
           curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall;
           chmod +x msfinstall;
           ./msfinstall;
           echo run "${YELOW}[ msfdb ]${ENDCOLOR}";;

    2004 )  pkg install -y git;
            git clone https://github.com/Cesar-Hack-Gray/SocialSploit;
            cd SocialSploit;
            ls;
            bash install.sh;
            ./Sploit;;

    2005 ) echo installing Havoc Client;
           sleep 5;
           echo installing prerequisites;
           sudo apt install -y git build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go qtbase5-dev libqt5websockets5-dev libspdlog-dev python3-dev libboost-all-dev mingw-w64 nasm ;
           echo 'deb http://ftp.de.debian.org/debian bookworm main' >> /etc/apt/sources.list
           sudo apt update
           sudo apt install python3-dev python3.10-dev libpython3.10 libpython3.10-dev python3.10
           git clone https://github.com/HavocFramework/Havoc.git;
           cd Havoc/Client;
           make ;
           cd Havoc/Client;
           chmod +x Havoc ;
           ./Havoc;;
    
    2006 ) echo installing Havoc Team server;
           sleep 5;
           cd Havoc/Teamserver;
           go mod download golang.org/x/sys;
           go mod download github.com/ugorji/go;
           cd Teamserver
           # Install MUSL C Compiler
           ./Install.sh
           # Build Binary
           make
           ./teamserver -h
           # Run the teamserver
           sudo ./teamserver server --profile ./profiles/havoc.yaotl -v --debug
           echo "${RED}[ The users are the defaults ones, remember to change theme ]${RED}";
           sleep 5;
           ./teamserver -h;;

# Wireles atcks
    3001 ) git clone https://github.com/derv82/wifite2.git ;
           cd wifite2 ;
           sudo ./Wifite.py ;
           sudo python setup.py install;;

# vulnerability detection
    4001 ) git clone https://github.com/CISOfy/lynis;
            cd lynis && ./lynis audit system;;

  

# Options
    op ) echo;
echo -e complete system setup "${YELOW}[systemsetup]${ENDCOLOR}";
echo -e system tools "${YELOW}[system]${ENDCOLOR}";
echo -e update "${YELOW}[update]${ENDCOLOR}";
echo -e install Osint tools "${YELOW}[1]${ENDCOLOR}";
echo -e install Exploit tools "${YELOW}[2]${ENDCOLOR}";
echo -e install Wireless tools "${YELOW}[3]${ENDCOLOR}";
echo -e install vulnerability detection tools "${YELOW}[4]${ENDCOLOR}";
echo -e show options "${YELOW}[op]${ENDCOLOR}";
echo -e show version "${YELOW}[v]${ENDCOLOR}";
echo ;;

    help )  echo;
echo -e complete system setup "${YELOW}[systemsetup]${ENDCOLOR}";
echo -e system tools "${YELOW}[system]${ENDCOLOR}";
echo -e update "${YELOW}[update]${ENDCOLOR}";
echo -e install Osint tools "${YELOW}[1]${ENDCOLOR}";
echo -e install Exploit tools "${YELOW}[2]${ENDCOLOR}";
echo -e install Wireless tools "${YELOW}[3]${ENDCOLOR}";
echo -e install vulnerability detection tools "${YELOW}[4]${ENDCOLOR}";
echo -e show options "${YELOW}[op]${ENDCOLOR}";
echo -e show version "${YELOW}[v]${ENDCOLOR}";
echo ;;



# Project info
    v ) echo ;
        echo ;
        echo         ====================; 
        echo         =___Open_Testing___=;
        echo         =__________________=;
        echo         =_version_1.4_BETA_=;
        echo         =___OS:_Debian_11__=;
        echo         =_____AROA-DEV_____=;
        echo         ====================;
        echo ;
        echo ;;

# system tool

    sinfo ) neofetch;;

    clear ) clear;;

# user settings
    newuser ) echo -n "Enter the username: ";
              read new;
              useradd $new;
              sudo adduser $new ;;

    remuveuser ) echo -n "Enter the username that you whant to remuve: ";
                 read remuve;
                 userdel -r $remuve;
                 sudo deluser $remuve;
                 cd /;
                 cd home;
                 rm -rf $remuve;;

# Network check
    ip ) ip addr;;

    ping ) echo -n "what would you like to ping: ";
           read $chek;
           ping $check;;

# remote access to system 

    sshserver ) sudo apt install openssh-server;
               sudo systemctl start ssh;
               sudo systemctl status ssh;
               sudo systemctl enable ssh;;


    xrdp ) sudo apt install ufw -y;
           apt install xrdp;
           sudo systemctl status xrdp;
           sudo adduser xrdp ssl-cert;
           sudo systemctl restart xrdp;
           sudo systemctl enable xrdp;
           sudo ufw allow ;;


# power
    sreboot ) reboot;
              systemctl reboot;;
        
    sshutdown ) shutdown;
                systemctl shutdown;;

# full system set up

    systemsetup ) apt install sudo;
                  cd /;
                  cd bin;
                  wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/automator; # change link when pass to release version;
                   #wget https://raw.githubusercontent.com/AROA-DEV/automator/main/automator;
                  chmod +x automator;
                  wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/automator-update; # change link when pass to release version;
                  # wget https://raw.githubusercontent.com/AROA-DEV/automator/main/automator-update;
                  chmod +x automator-update;
                  cd /;
                  apt update -y && apt upgrade -y;
                  apt install -y git;
                  apt install -y python;
                  apt install -y python3;
                  apt install -y python3-pip;
                  apt install -y curl;
                  apt-get install -y wget;
                  apt-get install -y nmon;
                  apt install -y neofetch;
                  apt update -y && apt upgrade -y;
                  echo -e "${RED} Will reboot in 10s pres [ctrl + c] ${ENDCOLOR}";
                  sleep 10;
                  reboot;
                  systemctl reboot -i ;;

    update ) apt update -y && apt upgrade -y;;

# invalid option (keep last)    
    * ) echo invalid response run [help] ;;    
esac

done

echo doing stuff...