#!/bin/bash

virt-install \
--connect qemu:///system \
--name mgr-ovirt-01 \
--disk path=/var/lib/libvirt/images/mgr-ovirt-01,size=45 \
--memory 4096 \
--vcpus 2 \
--network bridge=br0  \
--graphics vnc \
--autostart \
-l http://192.168.1.64/inst \
-x ks=http://192.168.1.64/files/mgr-ovirt-01_ks.cfg \

