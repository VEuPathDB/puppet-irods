# rmresc Name (remove resource)
# Remove a storage resource.
#
define irods::lib::icommands::mkresc (
  $resc = undef,
  $type = undef,
  $path = undef,
  $ctxs = undef,
) {

  $command = "iadmin mkresc ${resc} ${type} ${path} ${ctxs}"

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    onlyif      => "iadmin lr ${resc} |grep -q 'No rows found'",
  }

}
