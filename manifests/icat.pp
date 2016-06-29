# installs iCAT server
class irods::icat (
  $core_version  = $irods::params::core_version,
  Enum['postgres','oracle','mysql'] $db_vendor = $irods::params::db_vendor,
  $db_name     = $irods::params::db_name,
  $db_user     = $irods::params::db_user,
  $db_password = $irods::params::db_password,
  $db_srv_host = $irods::params::db_srv_host,
  $db_srv_port = $irods::params::db_srv_port,
  $do_setup    = $irods::params::do_setup,
  $use_ssl     = $irods::globals::use_ssl,
) inherits irods::params {

  include ::irods::service

  contain irods::icat::setup
  Irods::Lib::Install['icat'] ~>
  Class['irods::icat::setup'] ->
  Irods::Lib::Ssl['icat']

  irods::lib::install { 'icat':
    packages     => ['irods-icat', "irods-database-plugin-${db_vendor}"],
    core_version => $core_version,
  }

  if $use_ssl {
    irods::lib::ssl { 'icat':
      ssl_certificate_chain_file_source => $irods::globals::ssl_certificate_chain_file_source,
      ssl_certificate_key_file_source   => $irods::globals::ssl_certificate_key_file_source,
    }
  }

}
