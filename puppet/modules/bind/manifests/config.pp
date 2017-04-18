class bind::config inherits bind {

    file { "${confdir}/named.conf":
        ensure => file,
        mode => "${filemode}",
        owner => "${owner}",
        group => "${group}",
        source => 'puppet:///modules/bind/named.conf',
    }
    file { "${zonedir}":
        ensure => directory,
        mode => "${dirmode}",
        owner => "${owner}",
        group => "${group}",
    }
    
    file { "${zonedir}/${domain}.zone":
        ensure => file,
        mode => "${filemode}",
        owner => "${owner}",
        group => "${group}",
        source => "puppet:///modules/bind/lukepafford.com.zone",
    }

     file { "${zonedir}/${domain}.rr.zone":
        ensure => file,
        mode => "${filemode}",
        owner => "${owner}",
        group => "${group}",
        source => "puppet:///modules/bind/lukepafford.com.rr.zone",
    }
}
