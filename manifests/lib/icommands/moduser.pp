# moduser Name[#Zone] [ type | zone | comment | info | password ] newValue
#
define irods::lib::icommands::moduser (
  String           $user   = undef,
  Enum[
    'type',
    'zone',
    'comment',
    'info',
    'password',
  ]                 $field = undef,
  String            $value = undef,
) {

  $command = "iadmin mkuser ${user} ${type}"

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    onlyif      => "iadmin lr ${resc} |grep -q 'No rows found'",
 }

}
