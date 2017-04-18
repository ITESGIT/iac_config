#!/bin/bash

virt-install \
--connect qemu+ssh://lukepafford@VH-KVM-01/system \
--os-variant rhel7 \
--name dhcp-isc-01 \
--disk path=/var/lib/libvirt/images/dhcp-isc-01,size=30 \
--memory 2048 \
--vcpus 1 \
--network bridge=br0  \
--graphics vnc \
--autostart \
-l https://lukepafford.com/inst \
-x ks=https://lukepafford.com/files/dhcp-isc-01_ks.cfg 

