# The RENCI RPM packages contain overlapping files (especially the
# icommands) so we have to try to ensure only one core package is
# installed at at time - handling cases, for example, when an
# irods::client is changed to irods::resource.
define irods::install (
  $packages = undef,
  $version  = $irods::params::version
) {

  if is_array($packages) {
    $pkg_array = $packages
  } else {
    $pkg_array = [$packages]
  }

  case $::osfamily {
    'RedHat': {
      $core_packages = $irods::params::core_packages
      $rm_pkgs = difference($core_packages, $pkg_array)
    }
    default: {
      $rm_pkgs = []
    }
  } 

  package { $rm_pkgs:
    ensure => absent,
  } ->
  package { $pkg_array:
    ensure => $version,
  }

}
