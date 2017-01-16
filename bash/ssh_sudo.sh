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

# Example Scenario:

# I update the zone configuration file for dns and write a script 
# to update the dns server:

# scp user@central_conf_server:/path/to/zoneconf.zone ~/
# sudo mv ~/zoneconf.zone /var/named/zoneconf.zone
# sudo chown named:named /var/named/zoneconf.zone
# sudo chmod 664 /var/named/zoneconf.zone

# I save the script at ~/dnsupdate.sh

# Assuming SSH, and sudoers has been properly configured I can then
# run the following command with no interaction:

# ssh_sudo.sh ~/dnsupdate.sh dns_server

# With creativity, you can create cron jobs that perform
# remote tasks with only minimal privileges granted.

# Display usage to user
if [[ $# -lt 2 || $# -gt 2 ]]; then
    echo "Usage: Remote_commands.sh script.sh remote_host"
    exit 1
fi

# Confirm the script file exists
if [ ! -f "$1" ]; then
    echo "File "$1" does not exist" 
    exit 1
fi

# Confirm the remote hosts can be pinged
if ! ping -c 1 "$2" > /dev/null 2>&1; then
    echo "Cannot connect to host: $2" 
    exit 1
fi

script=$(base64 -w0 $1)
ssh -t "$2" "echo $script | base64 -d | bash"
