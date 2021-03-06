# Prompt for password to be used to configure all accounts. This single password is just used
# For lab purposes. Prod should have one password for each account

read -s -p "Enter password to be used for freeipa client join and admin accounts"

# Create lukepafford admin account
useradd lukepafford
usermod -aG wheel lukepafford
echo "$REPLY" | passwd --stdin lukepafford

# Perform yum update before installing server
yum update -y

# Install ovirt repository
yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm -y

# Install the ovirt engine packages
yum -y install ovirt-engine

# Run Engine setup ( provide answer files to script this)
