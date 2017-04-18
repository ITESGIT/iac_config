#!/bin/bash
# Script that will configure postfix on centos 7


# Modify these values to configure for your environment
DOMAIN=lukepafford.com
HOSTNAME=rhce-smtp.lukepafford.com
POSTFIX=/etc/post/main.cf
ACL=192.168.1.210/28


# Do not modify below this line
# ---------------------------------------------------------
# ---------------------------------------------------------
# 1. Install packages

    yum install -y postfix

# 2.  Enable firewall
    
    firewall-cmd --permanent --add-service=smtp
    firewall-cmd --reload

# 3. Configure the postfix conf file

    postconf -e "myhostname = $HOSTNAME"
    postconf -e "mydomain   = $DOMAIN"
    postconf -e 'myorigin   = $mydomain'
    postconf -e 'mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain'
    postconf -e "inet_interfaces = all"
    postconf -e "mynetworks = $ACL"

# 4. Enable and restart the service

    systemctl restart postfix
    systemctl enable postfix

