class cacti::redirect {
  file { '/etc/apache2/conf.d/cacti-redirect.conf':
    ensure  => file,
    source  => 'puppet://modules/cacti/etc/apache2/conf.d/cacti-redirect.conf',
    require => Package['cacti'];
  }
}
