#!/bin/bash
# Script that will configure postfix on centos 7


# Modify these values to configure for your environment
DOMAIN=$(hostname -d)
HOSTNAME=$(hostname)
EMAIL_SERVER=rhce-smtp.lukepafford.com
POSTFIX=/etc/post/main.cf
ACL=192.168.1.210/28


# Do not modify below this line
# ---------------------------------------------------------
# ---------------------------------------------------------
# 1. Install packages

    yum install -y postfix


# 2. Configure the postfix conf file

    postconf -e "myhostname = $HOSTNAME"
    postconf -e "mydomain   = $DOMAIN"
    postconf -e 'myorigin   = $mydomain'
    postconf -e 'mydestination = '
    postconf -e "local_transport = error: local mail delivery is disabled"
    postconf -e "relayhost = $EMAIL_SERVER"
    postconf -e "inet_interfaces = localhost"
    postconf -e "mynetworks = $ACL"

