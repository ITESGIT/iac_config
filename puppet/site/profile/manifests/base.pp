class profile::base {
  class { 'sshd':}
  class { 'user_config': }
  class { 'base': }
}
