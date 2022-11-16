# automator Beta

Get automator
> :warning: These are made and tested for Debian11 somethings may work on other distros using the apt package manager (Dedicated scripts are coming)
````
 wget https://raw.githubusercontent.com/AROA-DEV/automator/main/automator.sh
````
testing branch
````
 wget https://raw.githubusercontent.com/AROA-DEV/automator/Beta-testing/automator.sh
````
make automator script runable
````
 chmod +x automator.sh
````
run automator
````
 ./automator.sh
````
run "systemsetup" to be able to run it from any location

## The automated setup (:warning: Concept :warning:)
````
wget https://raw.githubusercontent.com/AROA-DEV/Automator/Beta-testing/Dedicated/Automatorsetup.sh
````

````
chmod +x Automatorsetup.sh
````
````
./Automatorsetup.sh
````

tested os: Debian 11,
<details><summary>Features</summary>
<p>

# system:

 - system setup:
   - will install automator and automator-update on the system bin directory
   - extarnal tools that will be installed: git, python, python3, python3-pip, curl, wget, nmon, neofetch.
   
 - system:
   - some comands from the system ( sreboot, sshutdown, clear , ip , ping, new user, remuve user)

# and automated install for tools:

- Office tools:
 - 7zip

- Osint tools:
  - Osintgram
  - Recon-ng
  - phoneinfoga
  - nmap
  - Profil3r

- Exploit tools:
  - metasploit
  - setoolkit
  - metasploit install type 2
  - Havoc Client ( may need some changes in the future )
  - Havoc Team server ( may need some changes in the future )

- Wireles tools:
  - wifite2
  - wireshark

- vulnerability detection tools:
   - lynis
   
- Anty Virus
   - ClamAV

</p>
</details>

<details><summary>Upcoming features</summary>
<p>

Upcoming features:
( the check features checked are avaleable in the beta branch but havent made it to the release version )

- [ ] Docker install



</p>
</details>

