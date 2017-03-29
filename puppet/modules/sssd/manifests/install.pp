class sssd::install inherits sssd {

    # Loop through packages defined in hiera and 
    # ensure they are present
     $packages.each |String $item| {
        package { "$item":
           ensure => present,
         }
     }
}
