# Configure iRODS to use SSL.
# Adds changes to ~irods/.irods/irods_environment.json.
# Installs ssl certificates to /etc/irods/ssl/.
# Reloads irods server on change.
#
define irods::lib::ssl (
  $ssl_certificate_chain_file_source = '',
  $ssl_certificate_key_file_source   = '',
) {

  include ::irods::service

  $irods_environment_json = "${irods::globals::irods_home}/.irods/irods_environment.json"
  $env_json_entries = {
    'irods_ssl_certificate_chain_file' => '/etc/irods/ssl/server.crt',
    'irods_ssl_certificate_key_file'   => '/etc/irods/ssl/server.key',
    'irods_ssl_dh_params_file'         => '/etc/irods/ssl/dhparams.pem',
    'irods_client_server_policy'       => 'CS_NEG_REQUIRE',
  }

  $env_json_entries.each |$k, $v| {
    augeas { $k:
      incl    => $irods_environment_json,
      lens    => 'Json.lns',
      changes => [
        "set dict/entry[.= '${k}'] '${k}'",
        "set dict/entry[.= '${k}']/string '${v}'",
      ],
      notify  => Service['irods'],
    }
  }

  File {
    owner  => $irods::globals::srv_acct,
    group  => $irods::globals::srv_grp,
    mode   => '0640',
    notify => Service['irods'],
  }

  file { '/etc/irods/ssl':
    ensure  => 'directory',
  } ->

  file { '/etc/irods/ssl/server.key':
    ensure => 'file',
    source => $ssl_certificate_key_file_source,
  } ->

  file { '/etc/irods/ssl/server.crt':
    ensure => 'file',
    source => $ssl_certificate_chain_file_source,
  } ->

  exec { 'generate /etc/irods/ssl/dhparams.pem':
    path    => ['/usr/local/bin', '/bin', '/usr/bin'],
    command => 'openssl dhparam -2 -out /etc/irods/ssl/dhparams.pem 2048',
    user    => $irods::globals::srv_acct,
    creates => '/etc/irods/ssl/dhparams.pem',
    notify  => Service['irods'],
  }

}