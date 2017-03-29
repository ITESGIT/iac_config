#!/bin/bash

# enable SSSd
authconfig --enablesssd --enablesssdauth  --update

# Enable make homedir
authconfig --enablemkhomedir  --update


# Enable Kerberos Authnetication
authconfig --enablekrb5 --krb5realm LUKEPAFFORD.COM --krb5kdc dc-ad-01.lukepafford.com:88 --krb5adminserver dc-ad-01.lukepafford.com:749 --enablekrb5kdcdns --enablekrb5realmdns --update

# Enable smart card
#authconfig --enablesmartcard --smartcardaction=0 --update

# Enable Samba
#authconfig --smbsecurity ads --smbworkgroup LUKEPAFFORD --smbrealm LUKEPAFFORD.COM --update

# Enable Winbind
#authconfig --enablewinbind --enablewins --enablewinbindkrb5 --enablewinbindoffline --update

 
# Set proper permissions on config files
chown root:root /etc/sssd/sssd.conf
chmod 600 /etc/sssd/sssd.conf
