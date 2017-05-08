# STIG-ID: RHEL-07-010010
# Rule-ID: RHEL-07-010010_rule
# Vuln-ID: RHEL-07-010010
# Severity: CAT 1
# Class: Unclass

class stigs::redhat7::software_integrity::rhel_07_010010 inherits stigs::redhat7::redhat7 {
  
  if $rhel_07_010010 == 'present' {
    $file = 'file'
    $cron = 'present'
  }
  else {
    $file = 'absent'
    $cron = 'absent'
  }

  file { '/usr/local/bin/enforce-system-permissions.sh':
    ensure => $file, 
    source => 'puppet:///modules/stigs/redhat7/rhel_07_010010.sh',
    owner  => 'root',
    group  => 'root',
    mode   =>  '0750',
  }

  cron { 'STIG-ID: RHEL-07-010010':
    ensure  => $cron,
    command => '/usr/local/bin/enforce-system-permissions.sh',
    user    => 'root',
    hour    => 2,
    minute  => 0,
    require =>  File['/usr/local/bin/enforce-system-permissions.sh'],
  }

}
