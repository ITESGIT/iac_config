#!/bin/bash
# Created script based off guide at https://jamielinux.com/docs/openssl-certificate-authority
# The script will initialize a CA on a server if it does not exist
# This was a quick script with a lot of duplicate code that could easily be modularized with functions. The goal was to just setup a quick CA
# This script creates the root CA and the intermediate CA on the same server. This practice should NOT be used on production, and is only for testing purposes

# Declare variables
ca_dir=/root/ca
country=US
state=CA
locality=Corona
organization='Luke Ltd'
email=lukepafford@gmail.com

# Create CA directories
mkdir -p ${ca_dir}/{certs,crl,csr,newcerts,private}

# Change directories to the Root ca direcctory
cd "${ca_dir}"

# Ensure directories have proper permissions
chmod 700 'private'

# Create flat file databases
if [[ ! -f 'index.txt' ]]; then
	touch index.txt
fi

if [[ ! -f 'serial' ]]; then
	echo 1000 > serial
fi

# Configure the root ca
if [[ ! -f 'openssl.cnf' ]]; then
	cat > 'openssl.cnf' <<-EOF
	# OpenSSL root CA configuration file.
	# Copy to /root/ca/openssl.cnf.
	
	[ ca ]
	# man ca
	default_ca = CA_default
	
	[ CA_default ]
	# Directory and file locations.
	dir               = $ca_dir
	certs             = ${ca_dir}/certs
	crl_dir           = ${ca_dir}/crl
	new_certs_dir     = ${ca_dir}/newcerts
	database          = ${ca_dir}/index.txt
	serial            = ${ca_dir}/serial
	RANDFILE          = ${ca_dir}/private/.rand
	
	# The root key and root certificate.
	private_key       = ${ca_dir}/private/ca.key.pem
	certificate       = ${ca_dir}/certs/ca.cert.pem
	
	# For certificate revocation lists.
	crlnumber         = ${ca_dir}/crlnumber
	crl               = ${ca_dir}/crl/ca.crl.pem
	crl_extensions    = crl_ext
	default_crl_days  = 30
	
	# SHA-1 is deprecated, so use SHA-2 instead.
	default_md        = sha256
	
	name_opt          = ca_default
	cert_opt          = ca_default
	default_days      = 375
	preserve          = no
	policy            = policy_strict
	
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
	countryName_default             = $country 
	stateOrProvinceName_default     = $state
	localityName_default            = $locality
	0.organizationName_default      = $organization
	organizationalUnitName_default  =
	commmonName_default	 	= ${ENV::HOSTNAME}
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

# Create the root key
if [[ ! -f 'private/ca.key.pem' ]]; then
	echo "You will be prompted for a password for the root key"
	echo "This must be complex, and you should never lose this password"
	openssl genrsa -aes256 -out private/ca.key.pem 4096
fi

# Restrict the root key permissions
chmod 400 private/ca.key.pem

# Create the root certificate
if [[ ! -f 'certs/ca.cert.pem' ]]; then
	openssl req -config openssl.cnf -key private/ca.key.pem -new -x509 -days 7300 \
	-sha256 -extensions v3_ca -out certs/ca.cert.pem
fi

# Ensure all users can read the public root certificate
chmod 444 certs/ca.cert.pem
