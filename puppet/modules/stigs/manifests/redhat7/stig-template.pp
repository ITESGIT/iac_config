# STIG-ID: RHEL-07-
# Rule-ID: RHEL-07-_rule
# Vuln-ID: RHEL-07-
# Severity: CAT
# Class: Unclass

class stigs::redhat7::LOGICAL_GROUP::module_name inherits stigs::redhat7::redhat7 {

  if $rhel_07_000000 == 'present' {
    $file = 'file'
  }
  else {
    $file = 'absent'
  }

}
