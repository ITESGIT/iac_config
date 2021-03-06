#!/bin/bash

if [ ! -d /home/server_config ]; then
    sudo /usr/bin/mkdir /home/server_config
fi

# Make sure account can access /var/named directory
sudo /usr/bin/chmod 755 /var/named

# Ensure server_config home directory has proper permissions
sudo /usr/bin/chown server_config:service_accounts /home/server_config

# Copy master named conf and zone files from config server to dns server.
#scp server_config@centos7-l01:/home/lukepafford/Documents/iac_config/configuration_files/dns/master_named.conf ~
#scp server_config@centos7-l01:/home/lukepafford/Documents/iac_config/configuration_files/dns/lukepafford.com* ~

# Replace named conf file and set proper permissions
sudo /usr/bin/mv /home/server_config/master_named.conf /etc/named.conf
sudo /usr/bin/chown root:named /etc/named.conf
sudo /usr/bin/chmod 640 /etc/named.conf

# Replace zone files and set proper permissions
sudo /usr/bin/mv /home/server_config/*.zone /var/named
sudo /usr/bin/chown named:named /var/named/*.zone
sudo /usr/bin/chmod 640 /var/named/*.zone

# Reload named service
sudo /bin/systemctl reload named
