#!/bin/bash

# Add the pulp repository
yum-config-manager --add-repo https://repos.fedorapeople.org/repos/pulp/pulp/rhel-pulp.repo

# the EPEL 7 repository is required
sudo yum install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y

# Pulp runs on the MongoDB datbase.
sudo yum install mongodb-server -y

# Configure the database to start at startup and start
sudo systemctl enable mongod
sudo systemctl start mongod

# Pulp requires a message bus. This could be it's own server but we will
# Configure the server to use it here. Pulp uses the Qpid message bus.
sudo yum install qpid-cpp-server qpid-cpp-server-linearstore -y

# Configure qpid to start on boot and start
sudo systemctl enable qpidd
sudo systemctl start qpidd

# Install the pulp server
sudo yum install pulp-server python-gofer-qpid python-qpid qpid-tools -y

# Install plugin support
sudo yum install pulp-rpm-plugins pulp-puppet-plugins pulp-docker-plugins -y

# Initialize the pulp database. The documentation EXPLICTLY REQURIES that the database
# initialization be ran with the apache user.
sudo -u apache pulp-manage-db

# Configure apache to start on boot and start
sudo systemctl enable httpd
sudo systemctl start httpd

# Enable and start the celerybeat proccess. The documentation says this services performs 
# similar roles to the cron service.
sudo systemctl enable pulp_celerybeat
sudo systemctl start pulp_celerybeat

# Enable and start the pulp resource manager. This process acts as a task router, deciding
# which worker performs certain tasks.
sudo systemctl enable pulp_resource_manager
sudo systemctl start pulp_resource_manager


