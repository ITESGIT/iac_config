#!/bin/bash

# Define variables
DOC_DIR=/home/lukepafford/Downloads/PDF/RedHat/wget_sync
DOC_LIST=/home/lukepafford/Documents/redhat_documentation_list.txt

# Create logical directories to organize documents
RHEL7="$DOC_DIR/RHEL7"
STORAGE="$DOC_DIR/storage"
NETWORKING="$DOC_DIR/networking"
CLUSTERING="$DOC_DIR/clustering"
IDENTITY="$DOC_DIR/identity"
SECURITY="$DOC_DIR/security"
SUBSCRIPTIONS="$DOC_DIR/subscriptions"
GLUSTER="$DOC_DIR/gluster_storage"
CEPH="$DOC_DIR/ceph_storage"
VIRTUALIZATION="$DOC_DIR/virtualization"
SATELLITE="$DOC_DIR/satellite"
CERTIFICATE="$DOC_DIR/certificate_system"


# Make directories
mkdir -p "$RHEL7"
mkdir -p "$STORAGE"
mkdir -p "$NETWORKING"
mkdir -p "$CLUSTERING"
mkdir -p "$IDENTITY"
mkdir -p "$SECURITY"
mkdir -p "$SUBSCRIPTIONS"
mkdir -p "$GLUSTER"
mkdir -p "$CEPH"
mkdir -p "$VIRTUALIZATION"
mkdir -p "$SATELLITE"
mkdir -p "$CERTIFICATE"


# Download all the redhat documentation specified in the redhat_file_list.txt file.
# the -N option ensures a file is only downloaded if it is newer than the existing file
wget --directory-prefix="$DOC_DIR" -i "$DOC_LIST" -N

# Organzie documentation
for file in $(find /home/lukepafford/Downloads/PDF/RedHat/wget_sync -maxdepth 1 -type f );do
        if [[ "$file" =~ "Storage_Administration_Guide" ]]; then    
            mv "$file" "$STORAGE"
        elif [[ "$file" =~ "Logical_Volume_Manager_Administration" ]]; then
            mv "$file" "$STORAGE"
       elif [[ "$file" =~ "Networking_Guide" ]]; then
            mv "$file" "$NETWORKING"
       elif [[ "$file" =~ "High_Availability" ]]; then
            mv "$file" "$CLUSTERING"
       elif [[ "$file" =~ "Load_Balancer_Administration" ]]; then
            mv "$file" "$CLUSTERING"
       elif [[ "$file" =~ "Global_File_System" ]]; then
            mv "$file" "$CLUSTERING"
       elif [[ "$file" =~ "Linux_Domain_Identity_Authentication" ]]; then
            mv "$file" "$IDENTITY"
       elif [[ "$file" =~ "System-Level_Authentication" ]]; then
            mv "$file" "$IDENTITY"
       elif [[ "$file" =~ "Windows_Integration_Guide" ]]; then
            mv "$file" "$IDENTITY"
       elif [[ "$file" =~ "SELinux" ]]; then
            mv "$file" "$SECURITY"
       elif [[ "$file" =~ "Security_Guide" ]]; then
            mv "$file" "$SECURITY"
       elif [[ "$file" =~ "Red_Hat_Subscription_Management" ]]; then
            mv "$file" "$SUBSCRIPTIONS"
       elif [[ "$file" =~ "Red_Hat_Storage" ]]; then
            mv "$file" "$GLUSTER"
       elif [[ "$file" =~ "Red_Hat_Ceph_Storage" ]]; then
            mv "$file" "$CEPH"
       elif [[ "$file" =~ "Red_Hat_Virtualization" ]]; then
            mv "$file" "$VIRTUALIZATION" 
       elif [[ "$file" =~ "Satellite" ]]; then
            mv "$file" "$SATELLITE"
       elif [[ "$file" =~ "Red_Hat_Certificate_System" ]]; then
            mv "$file" "$CERTIFICATE"
       else
            mv "$file" "$RHEL7"
       fi
done

