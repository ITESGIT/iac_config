#!/bin/bash
ca_dir=/root/ca

if [[ "$#" -eq 0 ]]; then
	echo "Usage: $0 csr_file"
	exit 1
fi

cd "${ca_dir}"

# Get basename of the csr
csr_name=$(basename $1)

openssl ca -config openssl.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in $1 -out certs/${csr_name}.signed

chmod 444 certs/${csr_name}.signed
