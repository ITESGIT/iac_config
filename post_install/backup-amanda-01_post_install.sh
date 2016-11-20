#!/bin/bash

# Install amanda backup packages
yum -y install amanda*

# Install xinetd and related packages
yum install xinetd gnuplot perl-ExtUtils-Embed

# enable and start xinetd service
systemctl enable xinetd
systemctl restart xinetd





