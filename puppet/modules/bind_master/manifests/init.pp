class bind_master ($domain) { 
  
    case $::operatingsystem {
        'centos': { $bind_pkg = 'bind' }
        default:  { fail("unrecognized operating system") }
    }

    package { $bind_pkg:
        ensure => present,
    }

    file { '/etc/named.conf':
        ensure => file,
        mode => '0640',
        owner => 'root',
        group => 'named',
        source => 'puppet:///modules/bind_master/named.conf',
      	require => Package["$bind_pkg"],
    }

    file { "/var/named/${domain}.zone":
        ensure => file,
        mode => '0640',
        owner => 'root',
        group => 'named',
        source => "puppet:///modules/bind_master/${domain}.zone",
      	require => Package["$bind_pkg"],
    }

     file { "/var/named/${domain}.rr.zone":
        ensure => file,
        mode => '0640',
        owner => 'root',
        group => 'named',
        source => "puppet:///modules/bind_master/${domain}.rr.zone",
      	require => Package["$bind_pkg"],
    }

   service { 'named':
      ensure => running,
      enable => true,
      require => Package["$bind_pkg"],
    }

}
