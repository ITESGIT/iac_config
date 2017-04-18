class bind::service inherits bind {
    service { 'named':
      ensure => running,
      enable => true, 
    }

}


