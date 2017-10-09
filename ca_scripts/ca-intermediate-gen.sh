#!/bin/bash
# Created script based off guide at https://jamielinux.com/docs/openssl-certificate-authority
# The script will initialize a CA on a server if it does not exist
# This was a quick script with a lot of duplicate code that could easily be modularized with functions. The goal was to just setup a quick CA
# This script creates the root CA and the intermediate CA on the same server. This practice should NOT be used on production, and is only for testing purposes

# Declare variables
intermediate_ca_dir=/root/ca/intermediate
country_name=US
state=CA
locality=Corona
organization='Luke Ltd'
email=lukepafford@gmail.com

# Create the intermediate CA
mkdir -p ${intermediate_ca_dir}/{certs,crl,csr,newcerts,private}

# Change directories to the intermediate CA
cd "${intermediate_ca_dir}"

# Restrict access to the private directory
chmod 700 private

# Create flat file databases
if [[ ! -f index.txt ]]; then
	touch index.txt
fi

if [[ ! -f serial ]]; then
	echo 1000 > serial
fi

if [[ ! -f crlnumber ]]; then
	echo 1000 > crlnumber
fi

# Configure the intermediate CA
if [[ ! -f 'openssl.cnf' ]]; then 
	cat > openssl.cnf <<-EOF
	# OpenSSL root CA configuration file.
	# Copy to /root/ca/openssl.cnf.
	
	[ ca ]
	# man ca
	default_ca = CA_default
	
	[ CA_default ]
	# Directory and file locations.
	dir               = $intermediate_ca_dir
	certs             = ${intermediate_ca_dir}/certs
	crl_dir           = ${intermediate_ca_dir}/crl
	new_certs_dir     = ${intermediate_ca_dir}/newcerts
	database          = ${intermediate_ca_dir}/index.txt
	serial            = ${intermediate_ca_dir}/serial
	RANDFILE          = ${intermediate_ca_dir}/private/.rand
	
	# The root key and root certificate.
	private_key       = ${intermediate_ca_dir}/private/intermediate.key.pem
	certificate       = ${intermediate_ca_dir}/certs/intermediate.cert.pem
	
	# For certificate revocation lists.
	crlnumber         = ${intermediate_ca_dir}/crlnumber
	crl               = ${intermediate_ca_dir}/crl/intermediate.crl.pem
	crl_extensions    = crl_ext
	default_crl_days  = 30
	
	# SHA-1 is deprecated, so use SHA-2 instead.
	default_md        = sha256
	
	name_opt          = ca_default
	cert_opt          = ca_default
	default_days      = 375
	preserve          = no
	policy            = policy_loose
	
	[ policy_strict ]
	# The root CA should only sign intermediate certificates that match.
	# See the POLICY FORMAT section of man ca.
	countryName             = match
	stateOrProvinceName     = match
	organizationName        = match
	organizationalUnitName  = optional
	commonName              = supplied
	emailAddress            = optional
	
	[ policy_loose ]
	# Allow the intermediate CA to sign a more diverse range of certificates.
	# See the POLICY FORMAT section of the ca man page.
	countryName             = optional
	stateOrProvinceName     = optional
	localityName            = optional
	organizationName        = optional
	organizationalUnitName  = optional
	commonName              = supplied
	emailAddress            = optional
	
	[ req ]
	# Options for the req tool (man req).
	default_bits        = 2048
	distinguished_name  = req_distinguished_name
	string_mask         = utf8only
	
	# SHA-1 is deprecated, so use SHA-2 instead.
	default_md          = sha256
	
	# Extension to add when the -x509 option is used.
	x509_extensions     = v3_ca
	
	[ req_distinguished_name ]
	# See <https://en.wikipedia.org/wiki/Certificate_signing_request>.
	countryName                     = Country Name (2 letter code)
	stateOrProvinceName             = State or Province Name
	localityName                    = Locality Name
	0.organizationName              = Organization Name
	organizationalUnitName          = Organizational Unit Name
	commonName                      = Common Name
	emailAddress                    = Email Address
	
	# Optionally, specify some defaults.
	countryName_default             = $country_name 
	stateOrProvinceName_default     = $state
	localityName_default            = $locality
	0.organizationName_default      = $organization
	organizationalUnitName_default  =
	emailAddress_default            = $email
	
	[ v3_ca ]
	# Extensions for a typical CA (man x509v3_config).
	subjectKeyIdentifier = hash
	authorityKeyIdentifier = keyid:always,issuer
	basicConstraints = critical, CA:true
	keyUsage = critical, digitalSignature, cRLSign, keyCertSign
	
	[ v3_intermediate_ca ]
	# Extensions for a typical intermediate CA (man x509v3_config).
	subjectKeyIdentifier = hash
	authorityKeyIdentifier = keyid:always,issuer
	basicConstraints = critical, CA:true, pathlen:0
	keyUsage = critical, digitalSignature, cRLSign, keyCertSign
	
	[ usr_cert ]
	# Extensions for client certificates (man x509v3_config).
	basicConstraints = CA:FALSE
	nsCertType = client, email
	nsComment = "OpenSSL Generated Client Certificate"
	subjectKeyIdentifier = hash
	authorityKeyIdentifier = keyid,issuer
	keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
	extendedKeyUsage = clientAuth, emailProtection
	
	[ server_cert ]
	# Extensions for server certificates (man x509v3_config).
	basicConstraints = CA:FALSE
	nsCertType = server
	nsComment = "OpenSSL Generated Server Certificate"
	subjectKeyIdentifier = hash
	authorityKeyIdentifier = keyid,issuer:always
	keyUsage = critical, digitalSignature, keyEncipherment
	extendedKeyUsage = serverAuth
	
	[ crl_ext ]
	# Extension for CRLs (man x509v3_config).
	authorityKeyIdentifier=keyid:always
	
	[ ocsp ]
	# Extension for OCSP signing certificates (man ocsp).
	basicConstraints = CA:FALSE
	subjectKeyIdentifier = hash
	authorityKeyIdentifier = keyid,issuer
	keyUsage = critical, digitalSignature
	extendedKeyUsage = critical, OCSPSigning
EOF
fi

# Create the intermediate key
openssl genrsa -aes256 -out private/intermediate.key.pem 4096 && chmod 400 private/intermediate.key.pem

# Create the intermediate certifcate request
openssl req -config openssl.cnf -new -sha256 \
-key private/intermediate.key.pem \
-out csr/intermediate.csr.pem
