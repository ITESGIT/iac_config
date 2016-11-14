#!/bin/bash
# To run this command you must have the open-scap package
# installed

HOSTNAME="$(hostname)"
DATE="$(date +%Y-%m-%d_%H:%M:%S)" 

oscap xccdf eval --profile stig-rhel7-server-upstream --results-arf "$HOSTNAME"_"$DATE"-xccdf_results.xml --report "$HOSTNAME"_"$DATE"-xccdf_results.html /usr/share/xml/scap/ssg/content/ssg-centos7-xccdf.xml

