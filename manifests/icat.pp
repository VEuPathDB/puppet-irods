# installs iCAT server
class irods::icat (
  $core_version  = $irods::params::core_version,
  Enum['postgres','oracle','mysql'] $db_vendor = $irods::params::db_vendor,
  $db_user     = $irods::params::db_user,
  $db_password = $irods::params::db_password,
  $db_srv_host = $irods::params::db_srv_host,
  $db_srv_port = $irods::params::db_srv_port,
) inherits irods::params {

  
  irods::install { 'irods-icat':
    packages     => ['irods-icat', "irods-database-plugin-${db_vendor}"],
    core_version => $core_version,
  }

}
