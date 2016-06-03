# Run the iRODS interactive setup script, taking inputs from a response
# file. The response file is different on iCAT and resource servers.
#
# The setup script creates a log in
# /var/lib/irods/iRODS/installLogs/irods_setup.log
# making $setup_log_file superfluous in most/all cases.
#
define irods::setup (
  $setup_rsp_file = undef,
  $setup_rsp_tmpl = undef,
  $setup_log_file = 'irods_setup.log',
) {

  $staging_dir     = '/var/lib/irods/.puppetstaging'
  $setup_sh_sudo   = '/var/lib/irods/packaging/setup_irods.sh'
  $setup_sh_desudo = "/var/lib/irods/packaging/setup_irods_desudo.sh"

  file { $staging_dir:
    ensure => 'directory',
  } ->

  # Response file as input to the setup script.
  file { "${staging_dir}/${setup_rsp_file}":
    ensure  => 'file',
    content => template("irods/${setup_rsp_tmpl}"),
    mode    => '0600',
  } ->

  # remove 'sudo' from setup script to work around "must have a tty to
  # run sudo" errors when running in Puppet environemnt.
  exec { 'remove_sudo_from_setup_sh':
    path        => "/bin:/usr/bin", 
    command     => "sed 's/sudo //' < ${setup_sh_sudo} > ${setup_sh_desudo}; chmod 755 ${setup_sh_desudo}",
    refreshonly => true,
  } ->

  # The service_account.config needs to be remove to ensure the setup
  # script does not skip questions and get out of sync with inputs from
  # the response file.
  exec { 'remove_account_config':
    path        => "/bin:/usr/bin", 
    command     => 'rm /etc/irods/service_account.config',
    onlyif      => 'test -f /etc/irods/service_account.config',
    refreshonly => true,
  } ->

  exec { 'irods-icat-setup':
    path        => "/bin:/usr/bin", 
    command     => "${setup_sh_desudo} < ${staging_dir}/${setup_rsp_file} > ${$staging_dir}/${setup_log_file} 2>&1",
    refreshonly => true,
  }

}
