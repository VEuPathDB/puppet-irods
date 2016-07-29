# installs iCAT server
class irods::icat (
  String                            $core_version     = $irods::params::core_version,
  Enum['postgres','oracle','mysql'] $db_vendor        = $irods::params::db_vendor,
  String                            $db_name          = $irods::params::db_name,
  String                            $db_user          = $irods::params::db_user,
  String                            $db_password      = $irods::params::db_password,
  String                            $db_srv_host      = $irods::params::db_srv_host,
  String                            $db_srv_port      = $irods::params::db_srv_port,
  Boolean                           $do_setup         = $irods::params::do_setup,
  Boolean                           $use_ssl          = $irods::globals::use_ssl,
  Array                             $re_rulebase_set  = $irods::params::re_rulebase_set,
  Boolean                           $install_dev_pkgs = $irods::globals::install_dev_pkgs,
) inherits irods::params {

  include ::irods::service
  include ::irods::icat::re_rulebase_set

  contain ::irods::icat::setup
  Irods::Lib::Install['icat'] ~>
  Class['irods::icat::setup'] ->
  Class['irods::icat::re_rulebase_set'] ->
  Irods::Lib::Ssl['icat']

  $min_packages = ['irods-icat', "irods-database-plugin-${db_vendor}"]
  if $install_dev_pkgs {
    $packages = concat($min_packages, ['irods-dev', 'irods-runtime'])
  } else {
    $packages = $min_packages
  }

  irods::lib::install { 'icat':
    packages     => $packages,
    core_version => $core_version,
  }

  if $use_ssl {
    irods::lib::ssl { 'icat':
      ssl_certificate_chain_file_source => $irods::globals::ssl_certificate_chain_file_source,
      ssl_certificate_key_file_source   => $irods::globals::ssl_certificate_key_file_source,
    }
  }

}
