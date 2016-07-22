# mkgroup Name (make group)
# Create a user group.
# Also see atg, rfg, and rmgroup.
#
define irods::lib::icommands::mkgroup (
  String $group = undef,
) {

  $command = "iadmin mkgroup ${group}"

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    unless      => "iadmin lg | grep -q '^${group}$'",
  }

}
