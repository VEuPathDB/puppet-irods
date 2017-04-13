# The RENCI RPM packages contain overlapping files (especially the
# icommands) so we have to try to ensure only one core package is
# installed at at time - handling cases, for example, when an
# irods::client node is changed to a irods::resource node.
define irods::lib::install (
  $packages     = undef,
  $core_version = $irods::params::core_version,
  $manage_repo  = $irods::params::manage_repo,
) {

  if is_array($packages) {
    $install_pkgs = $packages
  } else {
    $install_pkgs = [$packages]
  }

  case $::osfamily {
    'RedHat': {
      $core_packages = $irods::params::core_packages
      $rm_pkgs = difference($core_packages, $install_pkgs)
      if $manage_repo {
        class {'irods::yum::install':
          before => Package[$install_pkgs],
        }
      }
    }
    default: {
      $rm_pkgs = []
    }
  }

  package { $rm_pkgs:
    ensure => absent,
  } ->
  package { $install_pkgs:
    ensure => $core_version,
  }

}
