# STIG-ID: RHEL-07-010031
# Rule-ID: RHEL-07-010031_rule
# Vuln-ID: RHEL-07-010031
# Severity: CAT II
# Class: Unclass
# Notes: This STIG's functionality has been implemented into rhel-07-010030 for being
# so similar, and difficult to configure in seperate manfiests
class stigs::redhat7::warning_banner::rhel_07_010031 inherits stigs::redhat7::redhat7 {

  #  if $rhel_07_010031 == 'present' {
  #    $ensure = 'present'
  #  }
  #  else {
  #    $ensure = 'absent'
  #  }
  #  
  #  $banner = @(EOF)
  #    'You are accessing a U.S. Government (USG) Information System (IS) that is
  #    provided for USG-authorized use only. By using this IS (which includes any
  #    device attached to this IS), you consent to the following conditions:
  #
  #    -The USG routinely intercepts and monitors communications on this IS for
  #    purposes including, but not limited to, penetration testing, COMSEC monitoring,
  #    network operations and defense, personnel misconduct (PM), law enforcement
  #    (LE), and counterintelligence (CI) investigations.
  #
  #    -At any time, the USG may inspect and seize data stored on this IS.
  #
  #    -Communications using, or data stored on, this IS are not private, are subject
  #    to routine monitoring, interception, and search, and may be disclosed or used
  #    for any USG-authorized purpose.
  #
  #    -This IS includes security measures (e.g., authentication and access controls)
  #    to protect USG interests -- not for your personal benefit or privacy.
  #
  #    -Notwithstanding the above, using this IS does not constitute consent to PM, LE
  #    or CI investigative searching or monitoring of the content of privileged
  #    communications, or work product, related to personal representation or services
  #    by attorneys, psychotherapists, or clergy, and their assistants. Such
  #    communications and work product are private and confidential. See User
  #    Agreement for details.'
  #    | EOF
  #
  #  if $ensure == 'present' {
  #    exec { 'create-banner-file':
  #      command => '/bin/touch /etc/dconf/db/local.d/01-banner-message',
  #      onlyif  => '/bin/test ! -f /etc/dconf/db/local.d/01-banner-message',
  #      before  =>  File_line['banner'],
  #    }
  #  }
  #
  #  if $ensure == 'present'{
  #    file_line { 'banner':
  #      ensure  => "${ensure}",
  #      path    => '/etc/dconf/db/local.d/01-banner-message',
  #      line    => "banner-message-text=${banner}",
  #    }
  #  }
  #
}
