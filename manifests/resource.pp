# installs resource server
class irods::resource (
  $core_version = $irods::params::core_version,
  $do_setup     = $irods::params::do_setup,
) inherits irods::params {

  if $irods::resource::do_setup == true {
    contain irods::resource_setup
    Irods::Install['resource'] ~>
    Class['irods::resource_setup']
  }

  irods::install { 'resource':
    packages     => ['irods-resource'],
    core_version => $core_version,
  }

}
