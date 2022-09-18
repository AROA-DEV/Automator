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
echo -e "${RED}!! recomended to run as root !!${ENDCOLOR}"
echo
echo -e compleate system setup "${RED}[!!!run ass root!!!]${ENDCOLOR}" "${YELOW}[systemsetup]${ENDCOLOR}"
echo -e update "${YELOW}[update]${ENDCOLOR}"
echo -e install Osint tools "${YELOW}[1]${ENDCOLOR}"
echo -e install Exploit tools "${YELOW}[2]${ENDCOLOR}"
echo -e install Wireles tools "${YELOW}[3]${ENDCOLOR}"
echo -e install vulnerability detection tools "${YELOW}[4]${ENDCOLOR}"
echo -e show options "${YELOW}[op]${ENDCOLOR}"
echo -e show version "${YELOW}[v]${ENDCOLOR}"
echo 
while true; do
read -p "how do you want to proceed? " yn

case $yn in 

# simple uptions output
    1 ) echo ;
        echo Remember the pakets will be installed onthe active directory;
        echo ;
        echo -e Osintgram  "${YELOW} [1001]${ENDCOLOR}";
        echo -e Recon-ng   "${YELOW} [1002]${ENDCOLOR}";
        echo -e phoneinfoga "${YELOW} [1003]${ENDCOLOR}";
        echo -e nmap      "${YELOW} [1004]${ENDCOLOR}";
        echo ;;

    2 ) echo ;
        echo -e metasploit "${YELOW} [2001]${ENDCOLOR}";
        echo -e setoolkit "${YELOW} [2002]${ENDCOLOR}";
        echo -e metasploit "${YELOW} [2003]${ENDCOLOR}";
        echo ;;

    3 ) echo ;
        echo -e Wifite     "${color} [3001]${ENDCOLOR}";
        echo ;;
    
    4 ) echo ;
        echo -e lynis     "${color} [4001]${ENDCOLOR}";
        echo ;;
    
# OSINT options
    1001 ) git clone https://github.com/AROA-DEV/Osintgram.git;
           cd Osintgram;
           pip3 install -r requirements.txt;
           wget https://github.com/AROA-DEV/Tool-Instructions/blob/main/Osintgram/usage.txt; 
           cd .. ;;

    1002 ) git clone https://github.com/lanmaster53/recon-ng.git ;;

    1003 ) mkdir Phoneinfoga ;
           cd PhoneInfoga ;
           wget https://github.com/AROA-DEV/Tool-Instructions/blob/main/phoneinfoga/usage.txt ;
           curl -sSL https://raw.githubusercontent.com/sundowndev/phoneinfoga/master/support/scripts/install | bash ;
           ./phoneinfoga version ;
           cd ..;;
        
    1004 ) apt update -y && apt upgarde -y;
           apt install nmap;
           apt upgarade -y;
           exit;;


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

# Wireles atcks
    3001 ) git clone https://github.com/derv82/wifite2.git ;
           cd wifite2 ;
           sudo ./Wifite.py ;
           sudo python setup.py install ;;

# vulnerability detection
    4001 ) git clone https://github.com/CISOfy/lynis
            cd lynis && ./lynis audit system;;

# Options
    op ) echo -e compleate system setup "${RED}[!!!run ass root!!!]${ENDCOLOR}" "${YELOW}[systemsetup]${ENDCOLOR}";
echo -e update "${YELOW}[update]${ENDCOLOR}";
echo -e install Osint tools "${YELOW}[1]${ENDCOLOR}";
echo -e install Exploit tools "${YELOW}[2]${ENDCOLOR}";
echo -e install Wireles tools "${YELOW}[3]${ENDCOLOR}";
echo -e install vulnerability detection tools "${YELOW}[4]${ENDCOLOR}";
echo -e show options "${YELOW}[op]${ENDCOLOR}";
echo -e show version "${YELOW}[v]${ENDCOLOR}";;

    help ) echo -e compleate system setup "${RED}[!!!run ass root!!!]${ENDCOLOR}" "${YELOW}[systemsetup]${ENDCOLOR}";
echo -e update "${YELOW}[update]${ENDCOLOR}";
echo -e install Osint tools "${YELOW}[1]${ENDCOLOR}";
echo -e install Exploit tools "${YELOW}[2]${ENDCOLOR}";
echo -e install Wireles tools "${YELOW}[3]${ENDCOLOR}";
echo -e install vulnerability detection tools "${YELOW}[4]${ENDCOLOR}";
echo -e show options "${YELOW}[op]${ENDCOLOR}";
echo -e show version "${YELOW}[v]${ENDCOLOR}";;

# Project info
    v ) echo ;
        echo ;
        echo         ====================; 
        echo         =___Open_Testing___=;
        echo         =__________________=;
        echo         =_version_1.1_beta_=;
        echo         =___OS: _linux_____=;
        echo         =______AROA-DEV____=;
        echo         ====================;
        echo ;
        echo ;;

# full system set up

    systemsetup ) apt install sudo;
                  cd /
                  cd bin
                  wget https://raw.githubusercontent.com/AROA-DEV/automator/main/automator
                  chmod +x automator
                  cd /
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
                  systemctl reboot -i ;;

    update ) apt update -y && apt upgrade -y;;

# invalid option (keep last)    
    * ) echo invalid response;;    
esac

done

echo doing stuff...