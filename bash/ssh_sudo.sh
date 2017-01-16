#!/bin/bash

# There are numerous different ways on the internet that claim
# to run sudo commands over SSH, but every example that I've encountered
# either doesn't work, or is an insecure solution.
# The only working solution for Centos 7 that I've found
# was from ThoriumBR on Serverfault
# http://serverfault.com/questions/625641/how-can-i-run-arbitrarily-complex-command-using-sudo-over-ssh?noredirect=1&lq=1
# I have modified his solution to take positional parameters
# and do basic error checking.

# This script will allow you to write an entire shell script, with restricted
# sudo commands built in, and run it on a remote machine.
# The script will work assuming that the user is allowed to run
# the specific sudo commands on the remote machine.

# This script is designed for automation. 
# This can only be done if both the SSH keys for the account
# have been generated and distributed, and if the sudoers configuration
# allows the specific commands to be ran without a password

# This environment sounds difficult to setup, but the Directory server FreeIPA
# Solves both problems easily. If you upload your public key to FreeIPA, all the # machines in the domain have access to it.
# The sudoers configuration is a bit more involved. I have created
# a sudoers rule that groups together commands that you specify that 
# can be run by a specific user. 
# Think of this rule as ACLs for the sudoers list. 
# All machines in the domain can be affected by this rule, or you
# can specify a single machine.
# This allows for flexible, secure automation.

# Real Example Scenario:

# I update the master conf file for dns and write a script 
# to update the dns server:

# if [ ! -d /home/server_config ]; then
#    sudo /usr/bin/mkdir /home/server_config
#    sudo /usr/bin/chown server_config:service_accounts /home/server_config
# fi
#
# scp server_config@centos7-l01:/home/lukepafford/Documents/iac_config/configuration_files/dns/master_named.conf ~
# sudo /usr/bin/mv ~/master_named.conf /etc/named.conf
# sudo /usr/bin/chown root:named /etc/named.conf
# sudo /usr/bin/chmod 640 /etc/named.conf

# I save the script at ~/bin/update_master_dns.sh

# Assuming SSH, and sudoers has been properly configured I can then
# run the following command with no interaction:

# ssh_sudo.sh ~/update_master_dns.sh dns-bind-01

# --------------------------------------------------------
# With creativity, you can create cron jobs that perform
# remote tasks with only minimal privileges granted.
# --------------------------------------------------------

# Display usage to user
if [[ $# -lt 3 || $# -gt 3 ]]; then
    echo "Usage: Remote_commands.sh script.sh user remote_host"
    exit 1
fi

# Confirm the script file exists
if [ ! -f "$1" ]; then
    echo "File "$1" does not exist" 
    exit 1
fi

# Confirm the remote hosts can be pinged
if ! ping -c 1 "$3" > /dev/null 2>&1; then
    echo "Cannot connect to host: $3" 
    exit 1
fi

script=$(base64 -w0 $1)
ssh -t "$2@$3" "echo $script | base64 -d | bash"
