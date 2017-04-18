class profile::bind (
  String $domain = hiera('profiles::bind::domain'),
  String $filemode = hiera('profiles::bind::filemode'),
  String $dirmode = hiera('profiles::bind::dirmode'),
  String $owner = hiera('profiles::bind::owner'),
  String $group = hiera('profiles::bind::group'),
  String $confdir = hiera('profiles::bind::confidr'),
  String $zonedir = hiera('profiles::bind::zonedir'),
  Array $packages = hiera('profiles::bind::packages'),
) {
  class { 'bind':
    domain   => $domain,
    filemode => $filemode,
    dirmode  => $dirmode,
    owner    => $owner,
    group    => $group,
    confdir  => $confdir,
    zonedir  => $zonedir,
    packages => $packages,
  }
}

