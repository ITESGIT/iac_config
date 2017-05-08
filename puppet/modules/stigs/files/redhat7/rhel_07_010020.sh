#!/bin/bash


# Declare array to hold list of RPM packages we need to correct hashes for
declare -a SETHASH_RPM_LIST

# Create a list of files on the system having hashes different from what
# is expected by the RPM database

# This awk command is filtering out any results that don't have the 'c' value in the output.
# The 'c' means the file is a configuration file, so it is expected to be modified. other 
# system files should not be modified, and the package will be reinstalled if a contained
# file has been shown to be changed.
FILES_WITH_INCORRECT_HASHES=($(rpm -Va | grep '^..5' | awk '{ if ( $2 != "c") print $NF }'))

for FILE_PATH in "${FILES_WITH_INCORRECT_HASHES[@]}"
do
	RPM_PACKAGE=$(rpm -qf "${FILE_PATH}")
	SETHASH_RPM_LIST=("${SETHASH_RPM_LIST[@]}" "${RPM_PACKAGE}")
done

# Remove duplicate mention of same RPM in $SETHASH_RPM_LIST (if any)
SETHASH_RPM_LIST=( $(echo "${SETHASH_RPM_LIST[@]}" | sort -n | uniq) )

for RPM_PACKAGE in "${SETHASH_RPM_LIST[@]}"
do
	yum -y reinstall "${RPM_PACKAGE}"
done


