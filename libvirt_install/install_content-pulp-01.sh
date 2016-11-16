#!/bin/bash

virt-install \
--connect qemu+ssh://lukepafford@VH-KVM-01/system \
--name content-pulp-01 \
--disk path=/var/lib/libvirt/images/content-pulp-01,size=35 \
--memory 4096 \
--vcpus 1 \
--network bridge=br0  \
--graphics vnc \
--autostart \
-l http://192.168.1.64/inst \
-x ks=http://192.168.1.64/files/content-pulp-01_ks.cfg 


