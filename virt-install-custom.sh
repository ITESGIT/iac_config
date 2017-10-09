#!/bin/bash

if [[ "$#" -eq 0 ]]; then
	echo "Usage: $0 hostname"
	exit 1
fi

new_host="$1"
remote_user=lukepafford
remote_host=vh-kvm-01
domain=lukepafford.com

virt-install \
	--connect qemu:///system \
	--name ${new_host} \
	--disk path=/var/lib/libvirt/images/${new_host},size=35 \
	--memory 2048 \
	--vcpus 1 \
	--network network=default \
	--graphics vnc \
	--autostart \
	-l http://192.168.122.10/cblr/ks_mirror/Centos7 \
	-x inst.ks=http://192.168.122.10/cblr/kickstarts/virtual-dhcp-ks.cfg \
	-x SERVERNAME=${new_host}.${domain} 
