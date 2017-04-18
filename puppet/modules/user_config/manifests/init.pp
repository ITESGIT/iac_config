# Class: user_config
# ===========================
#
# Full description of class user_config here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'user_config':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class user_config {
	user { 'lukepafford':
		ensure => present,
		managehome => true,
		shell => '/bin/bash',
		groups => ['wheel'],
		comment => 'Luke Pafford',
	}
	
	file { ['/home/lukepafford/.vim/', '/root/.vim']:
		ensure => directory,
		source => 'puppet:///modules/user_config/vim',
		recurse => true,	
	}

  file { ['/home/lukepafford/.vimrc/', '/root/.vimrc']:
    ensure => file,
    source => 'puppet:///modules/user_config/vimrc',
    recurse => true,
  }

  file { '/etc/profile.d/export_path.sh':
    ensure       => file,
    mode         => '0755',
    source       => 'puppet:///modules/user_config/export_path.sh',
    sourceselect => 'all',
    replace      => true,
    owner        => 'root',
    group        => 'root',
  }

  service { 'puppet':
    enable => true,
    ensure => running,
  } 

    
}
