# installs consumer server
class irods::consumer (
  String    $core_version     = $irods::params::core_version,
  Boolean   $do_setup         = $irods::params::do_setup,
  Boolean   $use_ssl          = $irods::globals::use_ssl,
  Boolean   $install_dev_pkgs = $irods::globals::install_dev_pkgs,
) inherits irods::params {

  include ::irods::service

  contain ::irods::consumer::setup
  Irods::Lib::Install['consumer'] ~>
  Class['irods::consumer::setup'] ->
  Irods::Lib::Ssl['consumer']

  $min_packages = ['irods-server', 'irods-icommands']
  if $install_dev_pkgs {
    $packages = concat($min_packages, ['irods-devel', 'irods-runtime'])
  } else {
    $packages = $min_packages
  }

  irods::lib::install { 'consumer':
    packages     => $packages,
    core_version => $core_version,
  }

  if $use_ssl {
    irods::lib::ssl { 'consumer':
      ssl_certificate_chain_file_source => $irods::globals::ssl_certificate_chain_file_source,
      ssl_certificate_key_file_source   => $irods::globals::ssl_certificate_key_file_source,
    }
  }

}
