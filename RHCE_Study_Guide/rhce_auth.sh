#!/bin/bash

# 1.---------------------------------------------------------

# Install kerberos packages, and ldap packages

    yum -y install krb5-workstation pam_krb5 openldap-clients nss-pam-ldapd

# Install sssd packages

#    yum -y install sssd

# 2. --------------------------------------------------------

# Enable kerberos authentication

    authconfig --update --enablekrb5 --krb5kdc=rhce-kerberos --krb5adminserver=rhce-kerberos --krb5realm=LUKEPAFFORD.COM --enablekrb5kdcdns --enablekrb5realmdns

# Disable ldap auth ( temporarily )

    authconfig --update --disableldap
# Enable ldap authentication

    #authconfig --update --enableldap --ldapserver=ldap://rhce-ldap.lukepafford.com:389 --ldapbasedn="ou=people,dc=lukepafford,dc=com" --enablemkhomedir 

