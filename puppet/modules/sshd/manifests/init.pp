class sshd {
    package { 'openssh-server':
        ensure => present,
    }

    file { '/etc/ssh/sshd_config':
        owner    => root,
        group   => root,
        mode    => '0600',
        ensure  => file,
        source  => 'puppet:///modules/sshd/sshd_config',
        require => Package['openssh-server'],
    }

    service { 'sshd':
        ensure  => running,
        enable  => true,
        require => Package['openssh-server'],
    }
}

