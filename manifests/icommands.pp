# installs only the icommands
class irods::icommands (
  $core_version = $irods::params::core_version,
) inherits irods::params {

  irods::lib::install { 'irods-icommands':
    packages     => 'irods-icommands',
    core_version => $core_version,
  }

}
