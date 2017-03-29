#!/bin/bash

# Obtain kerberos credentials for a windows administrative user
kinit Administrator

# add machine to the domain using the net command
realm join lukepafford.com

# confirm the host principal is there for the system
klist -k

