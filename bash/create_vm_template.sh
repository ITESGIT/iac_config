#!/bin/bash
# Created: 20160117
# Author: Luke Pafford

# Home image directory. Modify this value
# if you store vms in a different location
libvirt=/var/lib/libvirt/images

# check for proper amount of arguments
if [[ "$#" -le 1 || "$#" -ge 3 ]]; then
    echo "Usage: clone_vm.sh vm_name template_type"
    echo "WARNING: This utility shuts down the VM that will create the template"
    exit 1
fi

# confirm the domain exists
if ! virsh dominfo "$1" > /dev/null 2>&1; then
   echo "Domain $1 does not exist."
   exit 1
fi

# confirm the doman disk image exists. Using standard .qcow2 extension
if [[ ! -f "$libvirt"/"$1".qcow2 ]]; then
    echo "Domain disk $libvirt/$1.qcow2 does not exist"
    exit 1
fi

# Shutdown the VM
virsh shutdown "$1" 

# Dump the XML file to a template
virsh dumpxml "$1" > "$libvirt"/"$2"_template.xml

# Copy the disk image to a template image
cp "$libvirt"/"$1".qcow2 "$libvirt"/"$2"_template.qcow2

# Point the template xml file to look at the disk template
sed -i -e "s/source file=.*/source file="$libvirt"/"$2"_template.qcow2 \/>/" "$libvirt"/"$2"_template.xml

# Run virt-sysprep on the disk
virt-sysprep -a "$libvirt"/"$2"_template.qcow2


