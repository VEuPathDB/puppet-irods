# NOTICE: Use irods::lib::icommands::mkuser to set password at user
# creation time. This is because I don't have a way to check if a
# password needs to change so I only set password when the user is
# created and never again after that.
#
# moduser Name[#Zone] [ type | zone | comment | info | password ] newValue
#
define irods::lib::icommands::moduser (
  String           $user   = undef,
  Enum[
    'type',
    'zone',
    'comment',
    'info',
    'password'
  ]                 $field = undef,
  String            $value = undef,
) {

  fail('Not yet implemented. Needs exec conditional.')

  if $field == 'password' {
    fail('Setting password is not supported with irods::lib::icommands::moduser. Use mkuser instead.')
  }

  $command = "iadmin moduser ${field} ${value}"

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    #onlyif      => "iadmin lr ${resc} |grep -q 'No rows found'",
  }

}
