# installs resource server
class irods::resource (
  $core_version = $irods::params::core_version,
) inherits irods::params {

  irods::install { 'irods-resource':
    packages     => ['irods-resource'],
    core_version => $core_version,
  }

  irods::setup { 'irods-resource':
  
  }
}
