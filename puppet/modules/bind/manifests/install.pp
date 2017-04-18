class bind::install inherits bind {

    # Loop through packages defined in hiera and 
    # ensure they are present
     $packages.each |String $item| {
        package { "$item":
           ensure => present,
         }
     }
}
