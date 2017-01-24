#!/bin/bash
# Created: 20170123
# Author:  Luke Pafford

# Define variables
config_dir="/tmp/nic_config"


# Create an array of hostnames
# This script uses an ipa command since I'm in a free IPA environment.
# Any tool such as ldapsearch connecting to your ldap backend will work as well

# Notice the syntax to populate the array. The double parenthesis are required
# to create a new element, instead of appending a single string
servers=( $(ipa host-find | grep 'Host\ name' | cut -d ':' -f 2) )

# Create structured directory to store results
mkdir -p "$config_dir"

# Loop through servers joined to domain, and copy nic configurations
for server in "${servers[@]}"; do

    # Create directory of server to store nic config in
    mkdir -p "$config_dir/$server"

    # Copy nic config to local directory
    scp "$server:/etc/sysconfig/network-scripts/ifcfg-*" "$config_dir/$server"

done

