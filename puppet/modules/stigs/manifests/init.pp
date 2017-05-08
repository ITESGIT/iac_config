class stigs {

  case $facts['os']['name'] {
    'CentOS', 'RedHat': {
       if $facts['os']['release']['major'] == '7' {
         include stigs::redhat7::redhat7
       }
       elsif $facts['os']['release']['major'] == '6' {
         include stigs::redhat6::redhat6
       }
    }
    default: {
      warning('This stigs module is not supported on this OS')
    }

  }

}
