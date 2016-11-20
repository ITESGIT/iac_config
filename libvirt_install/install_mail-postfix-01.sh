#!/bin/bash

virt-install \
--connect qemu+ssh://lukepafford@VH-KVM-01/system \
--name mail-postfix-01 \
--disk path=/var/lib/libvirt/images/mail-postfix-01,size=125 \
--memory 2048 \
--vcpus 1 \
--network bridge=br0  \
--graphics vnc \
--autostart \
-l http://192.168.1.64/inst \
-x ks=http://192.168.1.64/files/mail-postfix-01_ks.cfg 


