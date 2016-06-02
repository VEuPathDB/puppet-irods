# installs only the icommands
class irods::client (
  $version = $irods::params::version,
) inherits irods::params {

  irods::install { 'irods-icommands':
    packages => 'irods-icommands',
    version  => $version,
  }

}
