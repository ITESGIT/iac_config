class bind (
  String $domain,
  String $filemode,
  String $dirmode,
  String $owner,
  String $group,
  String $confdir,
  String $zonedir,
  Array $packages,
) { 
    contain bind::install
    contain bind::config
    contain bind::service

    Class['::bind::install'] ->
    Class['::bind::config'] ~>
    Class['::bind::service'] 

}
