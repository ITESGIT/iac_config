#!/bin/bash

# Manually configure hostname and hostfile
echo "192.168.122.14 dc-ipa-01.lukepafford.com dc-ipa-01" >> /etc/hosts
echo "dc-ipa-01.lukepafford.com" > /etc/hostname

#open required ports
systemctl start firewalld.service
systemctl enable firewalld.service
firewall-cmd --permanent --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,464/tcp,53/tcp,88/udp,464/udp,53/udp,123/udp}
firewall-cmd --reload

#install the required packages
yum install ipa-server ipa-server-dns

# The server is now ready to run the command "ipa-server-install" which is the main
# configuration utility. this is interactive. I am documenting the recommended responses
# to each question here, however ultimately these answers should be pregenerated in an answer file.
# this should theoretically allow for a complete automated install from the ground up for the IPA
# server

#Do you want to configure integrated DNS (Bind)? [no]: YES
#Server Host Name: dc-ipa-01.lukepafford.com (THIS MUST BE LOWERCASE)
#Please configure the Domain name lukepafford.com
#Please provide a realm name LUKEPAFFORD.com
#Directory Manager Password: (Encrypt a password in script)
#Confirm Password: 
#IPA admin password: (Encrypt a password in script)
#Confirm Password:
#Existing bind configuration detected. Overwrite?: YES
#Do you want to configure dns forwards?: YES
#Enter an IP address for a DNS forwarder, or press enter to skip: 8.8.8.8
#Enter an IP address for another DNS forwardser, or press enter to skip: 8.8.4.4
#Skip next ip forwarder prompt
#Do you want to configure the reverse zone?: YES
#Please specify the reverse zone name: [Use default]
#Do you want to configure the system with these values?: YES

