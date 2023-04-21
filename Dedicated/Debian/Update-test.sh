#!/bin/bash
RED="\e[31m"
YELOW="\e[33m"  
ENDCOLOR="\e[0m";

# set the repository URL and current version
url="https://raw.githubusercontent.com/AROA-DEV/Automator/Beta-testing/Dedicated/Debian/version.txt"
current_version="1.5.1"

# get the version from the remote file
remote_version=$(curl -s $url)

# compare the versions
if [[ "$current_version" != "$remote_version" ]]; then
    echo -e There is a new version available. Please update to version "${RED} $remote_version ${ENDCOLOR}".
else
    echo -e You are using the latest version "${YELOW} $current_version ${ENDCOLOR}";
fi