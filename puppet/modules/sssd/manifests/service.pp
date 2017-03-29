class sssd::service inherits sssd {
    service { 'sssd':
      ensure => running,
      enable => true, 
    }

}


