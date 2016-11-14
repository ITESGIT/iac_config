# This generic post install script will be used on every installed machine or server. Eventually I will develop a 
# "post_install.d" directory which will follow linux standards of modularizing things. I will run the post install script
# on every machine, and customize specific machines. Most examples will include the "join_domain" etc

# Prompt for password to be used to configure all accounts. This single password is just used
# For lab purposes. Prod should have one password for each account

read -s -p "Enter password to be used for freeipa client join and admin accounts"

# Create lukepafford admin account
useradd lukepafford
usermod -aG wheel lukepafford
echo "$REPLY" | passwd --stdin lukepafford

# Perform yum update before installing server
yum update -y

