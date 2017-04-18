class cacti::config {
  file { '/etc/httpd/conf.d/cacti.conf':
    mode   => '0644',
    source => 'puppet:///modules/cacti/cacti.conf',
  }
}
