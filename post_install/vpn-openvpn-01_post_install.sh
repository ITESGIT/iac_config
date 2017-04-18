#!/bin/bash

# Enable the epel-repository
yum -y install epel-repository

# install open vpn and required packages
yum -y install openvpn easy-rsa 

# Copy example config to working config

