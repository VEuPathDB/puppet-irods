# installs resource server
class irods::resource (
  $core_version = $irods::params::core_version,
  $do_setup     = $irods::params::do_setup,
  $use_ssl      = $irods::globals::use_ssl,
) inherits irods::params {

  include ::irods::service

  contain irods::resource::setup
  Irods::Lib::Install['resource'] ~>
  Class['irods::resource::setup'] ->
  Irods::Lib::Ssl['resource']

  irods::lib::install { 'resource':
    packages     => ['irods-resource'],
    core_version => $core_version,
  }

  if $use_ssl {
    irods::lib::ssl { 'resource':
      ssl_certificate_chain_file_source => $irods::globals::ssl_certificate_chain_file_source,
      ssl_certificate_key_file_source   => $irods::globals::ssl_certificate_key_file_source,
    }
  }

}
