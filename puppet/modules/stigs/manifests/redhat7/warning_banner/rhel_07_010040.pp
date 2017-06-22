# STIG-ID: RHEL-07-010040
# Rule-ID: RHEL-07-010040_rule
# Vuln-ID: RHEL-07-010040
# Severity: CAT II
# Class: Unclass

class stigs::redhat7::warning_banner::rhel_07_010040 inherits stigs::redhat7::redhat7 {

  if $rhel_07_010040 == 'present' {
    $file = 'file'
  }
  else {
    $file = 'absent'
  }

  file { '/etc/issue':
    ensure => $file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/stigs/redhat7/rhel_07_010040.txt',
  }
                           

}
