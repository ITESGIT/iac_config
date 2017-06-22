# STIG-ID: RHEL-07-010020
# Rule-ID: RHEL-07-010020_rule
# Vuln-ID: RHEL-07-010020
# Severity: CAT I
# Class: Unclass

class stigs::redhat7::software_integrity::rhel_07_010020 inherits stigs::redhat7::redhat7 {

  if $rhel_07_010020 == 'present' {
    $file = 'file'
    $cron = 'present'
  }
  else {
    $file = 'absent'
    $cron = 'absent'
  }

  file { '/usr/local/bin/enforce-system-hashes.sh':
    ensure => $file,
    source => 'puppet:///modules/stigs/redhat7/rhel_07_010020.sh',
    owner  => 'root',
    group  => 'root',
    mode   =>  '0770',
  }

  cron { 'STIG-ID: RHEL-07-010020':
    ensure  => $cron,
    command => '/usr/local/bin/enforce-system-hashes.sh',
    user    => 'root',
    hour    => 2,
    minute  => 5,
    require =>  File['/usr/local/bin/enforce-system-hashes.sh'],
  }

}
