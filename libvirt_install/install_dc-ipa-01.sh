#!/bin/bash

virt-install \
--connect qemu+ssh://lukepafford@VH-KVM-01/system \
--name dc-ipa-01 \
--disk path=/var/lib/libvirt/images/dc-ipa-01,size=35 \
--memory 1024 \
--vcpus 1 \
--network bridge=br0  \
--graphics vnc \
--autostart \
-l http://192.168.1.64/inst \
-x ks=http://192.168.1.64/files/dc-ipa-01_ks.cfg \

