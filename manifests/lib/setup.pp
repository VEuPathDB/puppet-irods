# Run the iRODS interactive setup script, taking inputs from a response
# file. The response file is different on provider and consumer servers.
#
# Logging to $setup_log_file. The setup script also creates a log in
# /var/lib/irods/log/setup_log.txt
#
define irods::lib::setup (
  $setup_rsp_file = undef,
  $setup_rsp_tmpl = undef,
  $setup_log_file = 'irods_setup.log',
) {

  $staging_dir     = '/var/lib/irods/.puppetstaging'
  $setup_py        = '/var/lib/irods/scripts/setup_irods.py'
  $db_vendor       = $::irods::provider::db_vendor

  file { $staging_dir:
    ensure => 'directory',
  } ->

  # Response file as input to the setup script.
  file { "${staging_dir}/${setup_rsp_file}":
    ensure  => 'file',
    content => template("irods/${setup_rsp_tmpl}"),
    mode    => '0600',
  } ->

  exec { 'irods-provider-setup':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => "python ${setup_py} < ${staging_dir}/${setup_rsp_file} > ${$staging_dir}/${setup_log_file} 2>&1",
    unless      => 'test -f /etc/irods/server_config.json'
  } 

}
