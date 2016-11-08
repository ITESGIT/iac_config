#!/bin/bash

virt-install \
--connect qemu+ssh://lukepafford@VH-KVM-01/system \
--name DC-IPA-01 \
--disk path=/var/lib/libvirt/images/dc-ipa-01,size=35 \
--memory 2048 \
--vcpus 2 \
--graphics vnc \
--autostart \
-l http://192.168.1.64/inst \
-x ks=http://192.168.1.64/files/freeipa_ks.cfg \

