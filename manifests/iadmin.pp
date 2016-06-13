# collect the `irods::iadmin` array of hashes to instantiate appropriate
# `irods::lib::iadmin` define types and add them to the catalog.
#
# Also log in as the iCAT admin to run iadmin commands.
#
class irods::iadmin {

  $iadmin_set = hiera_array('irods::iadmin', {})
  iadmin_collect($iadmin_set)

  file { '/root/.irods':
    ensure => 'directory',
    mode    => '0700',
  } ->

  file { '/root/.irods/irods_environment.json':
    ensure  => 'file',
    content => template("irods/irods_environment.json.erb"),
    mode    => '0600',
  } ->

  exec { 'irods_admin_iinit':
    path        => ['/usr/bin','/bin'],
    environment => ["HOME=/root"],
    command     => "echo ${irods::globals::icat_admin_pass} | iinit",
    unless      => 'iadmin lu > /dev/null 2>&1',
  }


}