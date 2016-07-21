# mkuser Name[#Zone] Type (make user)
# See `iadmin lt user_type` for list of types.
#
define irods::lib::icommands::mkuser (
  String           $user = undef,
  Enum[
    'rodsgroup',
    'rodsadmin',
    'rodsuser',
    'groupadmin'
  ]                 $type = undef,
) {

  $command = "iadmin mkuser ${user} ${type}"

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    onlyif      => "iadmin lu '${user}' |grep -q 'No rows found'",
  }

}
