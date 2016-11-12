# Prompt for password to be used to configure all accounts. This single password is just used
# For lab purposes. Prod should have one password for each account

read -s -p "Enter password to be used for freeipa directory server, and admin accounts: "

/usr/bin/echo "192.168.1.10 dc-ipa-01.lukepafford.com dc-ipa-01" >> /etc/hosts
/usr/bin/echo "dc-ipa-01.lukepafford.com" > /etc/hostname

echo NETWORKING=yes >> /etc/sysconfig/network
echo HOSTNAME=dc-ipa-01.lukepafford.com >> /etc/sysconfig/network
echo GAETWAY=192.168.1.254 >> /etc/sysconfig/network

# Create lukepafford admin account
useradd lukepafford
usermod -aG wheel lukepafford
echo "$REPLY" | passwd --stdin lukepafford

yum install ipa-server -y
yum install ipa-server-dns -y

# Download haveged and start service to generate entropy for
# ipa-server install
yum install haveged -y
systemctl start haveged

ipa-server-install --unattended --realm=LUKEPAFFORD.com --domain=lukepafford.com --ds-password="$REPLY" --admin-password="$REPLY" --hostname=dc-ipa-01.lukepafford.com --ip-address=192.168.1.10 --setup-dns --forwarder=8.8.8.8 --forwarder=8.8.4.4

