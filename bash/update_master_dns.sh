#!/bin/bash

if [ ! -d /home/server_config ]; then
    sudo /usr/bin/mkdir /home/server_config
    sudo /usr/bin/chown server_config:service_accounts /home/server_config
fi

scp server_config@centos7-l01:/home/lukepafford/Documents/iac_config/configuration_files/dns/master_named.conf ~
sudo /usr/bin/mv ~/master_named.conf /etc/named.conf
sudo /usr/bin/chown root:named /etc/named.conf
sudo /usr/bin/chmod 640 /etc/named.conf
