#!/bin/bash

virt-install \
--connect qemu+ssh://lukepafford@VH-KVM-01/system \
--name vpn-openvpn-01 \
--disk path=/var/lib/libvirt/images/vpn-openvpn-01,size=35 \
--memory 2048 \
--vcpus 1 \
--network bridge=br0  \
--graphics vnc \
--autostart \
-l https://192.168.1.64/inst?no_verify=1 \
-x ks=ttps://192.168.1.64/files/vpn-openvpn-01_ks.cfg?no_verify=1\
--dry-run 


