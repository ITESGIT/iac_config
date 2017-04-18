#!/bin/bash

# Install required epel repository for satellite packages
yum -y install epel-release 

# Install puppet 4.x
yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

# Install the foreman repos
yum -y install https://yum.theforeman.org/releases/1.14/el7/x86_64/foreman-release.rpm

# Install the foreman installer
yum -y install foreman-installer

# Configure firewall for Satellite services
firewall-cmd --permanent --add-service=RH-Satellite-6
firewall-cmd --reload
