#!/bin/bash

virt-install \
--connect qemu+ssh://lukepafford@VH-KVM-01/system \
--name centos7-ws01 \
--disk path=/var/lib/libvirt/images/centos7-ws01,size=35 \
--memory 1024 \
--vcpus 1 \
--network bridge=br0  \
--graphics vnc \
--autostart \
-l http://192.168.1.64/inst \
-x ks=http://192.168.1.64/files/centos7-ws01_ks.cfg 


