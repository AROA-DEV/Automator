#!/bin/bash
read distro </etc/issue
echo $distro
if [[ "$distro" = "Debian GNU/Linux bookworm/sid n l" ]];
then
    goto Debian:
else
    goto check2:
fi

# check for ubuntu
check2:
echo $distro
if [[ "$distro" = "Ubuntu GNU/Linux bookworm/sid n l" ]];
then
    goto Ubuntu:
else
    goto check3:
fi

# check for kali
check3:
echo $distro
if [[ "$distro" = "kali GNU/Linux bookworm/sid n l" ]];
then
    goto Kali:
else
    goto check4:
fi

# check for Arch
check4:
echo $distro
if [[ "$distro" = "Arch GNU/Linux bookworm/sid n l" ]];
then
    goto Arch:
else
    echo No suported OS detected some thing may not work
fi

Debian:
echo using Debian
sleep 5
exit

Ubuntu:
echo using Ubuntu
sleep 5
exit

Kali:
echo using kali
sleep 5
exit

Arch:
echo using Arch
sleep 5
exit