node default {
	notify { "System": 
      message => "This is ${::fqdn}, and it is running the ${::operatingsystem} operating system"
  }
  include sshd
  include user_config
  include base
 # include cacti
}

node 'puppet-server.lukepafford.com' {
  include ::role::puppet::server
}
#node 'dns-bind-01.lukepafford.com' {
 # include ::role::bind::master
#}

node 'dns-bind-01.lukepafford.com' {
  include role::bind 
}
