#!/bin/bash

virt-install \
--connect qemu+ssh://lukepafford@VH-KVM-01/system \
--name DC-IPA-01.lukepafford.com \
--disk path=/var/lib/libvirt/images/DC-IPA-01.lukepafford.com.img,size=35 \
--memory 2048 \
--vcpus 2 \
-l http://192.168.1.64/inst \
-x ks=http://192.168.1.64/files/freeipa_ks.cfg \

