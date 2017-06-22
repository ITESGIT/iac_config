#!/bin/bash
# This script will use the bandersnatch tool to locally mirror Python modules
# Python >= 3.5 must be installed on the machine to configure bandersnatch

# Python Install dir
PYTHON_DIR=/opt
# Set this variable equal to a location with the largest space
BANDER_DIR=/home/bandersnatch
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Ensure user is root
if [[ "${EUID}" != 0 ]]; then
	echo "Script must be executed as root"
	exit 1
fi

# Prerequisite packages
PREREQS=(
	wget
	gcc
	make
	virtualenv
)

# Ensure prerequisite packages are installed
for package in "${PREREQS[@]}"; do
	if ! which "${package}" > /dev/null 2>&1; then
		yum -y install "${package}"
	fi
done


# Download latest stable version of python
if [[ ! -d "${PYTHON_DIR}/Python-3.6.0" ]]; then
	wget https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tar.xz --directory-prefix "${PYTHON_DIR}"
	cd "${PYTHON_DIR}"

	# Unpack the tarball
	tar xvJf "${PYTHON_DIR}/Python-3.6.0.tar.xz"
	
	# Build the Python 3.6 package
	cd Python-3.6.0
	./configure
	make
	make install
fi

# Install latest stable version of bandersnatch
if [[ ! -d "${BANNER_DIR}" ]]; then
	virtualenv --python=python3.6 "${BANDER_DIR}"
	cd "${BANDER_DIR}"
	pip3.6 install -r https://bitbucket.org/pypa/bandersnatch/raw/stable/requirements.txt
fi

# Create empty configuration file
if [[ ! -f /etc/bandersnatch.conf ]]; then
	bandersnatch mirror
fi

# Change the bandersnatch mirror directory
sed -i -e "s|directory.*|directory = ${BANDER_DIR}|" /etc/bandersnatch.conf

# Begin syncing the PYPI modules
bandersnatch mirror
