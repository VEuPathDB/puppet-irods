# NOTICE: This definition also calls 'moduser password' to set the
# password for the newly created user. If the user already exists then
# moduser is not run. This means you can not change a user password
# unless you first remove the user and then recreate it. All this is due
# to the inability to test if the password value differs from what is
# already set for the user.
#
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
  String            $password = '',
) {

  $mkuser_command  = "iadmin mkuser ${user} ${type}"
  $moduser_command = "iadmin moduser ${user} password ${password}"

  exec { "mkuser_${name}":
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${mkuser_command}; echo ${mkuser_command} >> /var/lib/irods/.puppet_icommands.log",
    onlyif      => "iadmin lu '${user}' |grep -q 'No rows found'",
  }

  if $password != '' {
    exec { "moduser_${name}":
      path        => '/usr/bin',
      environment => ['HOME=/root'],
      command     => "${moduser_command}; echo ${moduser_command} >> /var/lib/irods/.puppet_icommands.log",
      subscribe   => Exec["mkuser_${name}"],
      refreshonly => true,
    }
  }

}
