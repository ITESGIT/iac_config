#!/bin/bash

# Install required packages
yum install -y tftp-server xinetd wget

#Enable and start services
systemctl enable tftp-server
systemctl enable xinetd
systemctl start xinetd
systemctl start tftp-server

# Configure Firewall
firewall-cmd --permanent --add-service=tftp
firewall-cmd --reload

# Disable selinux
sed -i -e 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
setenforce permissive

# Install and configure bootloader
yum install -y syslinux
cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot
cp /usr/share/syslinux/vesamenu.c32 /var/lib/tftpboot

# Create custom boot menu
mkdir /var/lib/tftboot/pxelinux.cfg
mkdir /var/lib/tftpboot/images

# Write contents of default boot menu to file
cat <<EOF > /var/lib/tftpboot/pxelinux.cfg/default
default vesamenu.c32
prompt 0
timeout 300
ONTIMEOUT local
MENU MARGIN 10
MENU ROWS 16
MENU TABMSGROW 21
MENU TIMEOUTROW 26
MENU COLOR BORDER 30;44         #20ffffff #00000000 none
MENU COLOR SCROLLBAR 30;44              #20ffffff #00000000 none
MENU COLOR TITLE 0              #ffffffff #00000000 none
MENU COLOR SEL   30;47          #40000000 #20ffffff
MENU BACKGROUND redhat.jpg
MENU TITLE PXE Menu

LABEL local
menu label Boot from ^local drive
localboot 0xffff

LABEL Centos 7 x86_64
MENU LABEL Centos 7 x86_64
KERNEL images/centos/7/x86_64/vmlinuz
APPEND initrd=images/centos/7/x86_64/initrd.img ip=dhcp method=http://http://mirror.centos.org/centos/7/os/x86_64/
EOF

# Create directory to store image
mkdir -p /var/lib/tftpboot/images/centos/7/x86_64/

# Download Centos media to images directory
wget --directory-prefix=/var/lib/tftpboot/images/centos/7/x86_64/ http://mirror.centos.org/centos/7/os/x86_64/images/pxeboot/vmlinuz

wget --directory-prefix=/var/lib/tftpboot/images/centos/7/x86_64/ http://mirror.centos.org/centos/7/os/x86_64/images/pxeboot/initrd.img 
