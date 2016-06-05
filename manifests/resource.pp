# installs resource server
class irods::resource (
  $core_version = $irods::params::core_version,
  $do_setup     = $irods::params::do_setup,
) inherits irods::params {

  if $irods::resource::do_setup == true {
    contain irods::resource::setup
    Irods::Lib::Install['resource'] ~>
    Class['irods::resource::setup']
  }

  irods::lib::install { 'resource':
    packages     => ['irods-resource'],
    core_version => $core_version,
  }

}
