class bind_master (
$domain,
$mode = '0640',
$owner = 'root',
$group = 'named',
$confdir = '/etc',
$zonedir = '/var/named',
) 
{ 
    case $::operatingsystem {
        'centos': { $bind_pkg = 'bind' }
         default:  { fail("unrecognized operating system") }
    }
    package { $bind_pkg:
        ensure => present,
    }
    file { '${confdir}/named.conf':
        ensure => file,
        mode => '0640',
        owner => '${owner}',
        group => '${group}',
        source => 'puppet:///modules/bind_master/named.conf',
      	require => Package["$bind_pkg"],
    }
    file { "${zonedir}/${domain}.zone":
        ensure => file,
        mode => '0640',
        source => "puppet:///modules/bind_master/${domain}.zone",
      	require => Package["$bind_pkg"],
    }
    file { "${zonedir}/${domain}.rr.zone":
        ensure => file,
        mode => '0640',
        owner => '${owner}',
        group => '${group}',
        source => "puppet:///modules/bind_master/${domain}.rr.zone",
      	require => Package["$bind_pkg"],
    }
   service { '${group}':
      ensure => running,
      enable => true,
      require => Package["$bind_pkg"],
    }

}
