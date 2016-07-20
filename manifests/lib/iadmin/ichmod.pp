# Usage: ichmod [-rhvVM] null|read|write|own userOrGroup dataObj|Collection ...
#  or    ichmod [-rhvVM] inherit Collection ...
#  or    ichmod [-rhvVM] noinherit Collection ...
#  -r  recursive - set the access level for all dataObjects
#              in the entered collection and subCollections under it
#  -v  verbose
#  -V  Very verbose
#  -M  Admin Mode
#  -h  this help
define irods::lib::iadmin::ichmod (
  Enum[
    'null',
    'read',
    'write',
    'own',
    'inherit',
    'noinherit'
  ]                 $action = undef,
  String            $user = '',
  String            $collOrDataObj =  undef,
  Enum[
    '',
    '-r',
    '-v',
    '-V',
    '-M'
  ]                 $option = '',
) {

  $command = "ichmod ${option} ${action} ${user} ${collOrDataObj}"
  $zone    = $::irods::globals::icat_server_zone

  case $action {
    inherit:   {
      $exec_check = "ils -A ${collOrDataObj} | grep -q 'Inheritance - Enabled'"
    }
    noinherit: {
      $exec_check = "ils -A ${collOrDataObj} | grep -q 'Inheritance - Disabled'"
    }
    default: {
      $exec_check = "ils -A ${collOrDataObj} | grep -q '${user}#${zone}:${action}'"
    }
  }


    #notify { "CHECK ${exec_check}": }

    #notify { "COMMAND ${command}":}

  exec { $name:
    path        => '/usr/bin',
    environment => ["HOME=/root"],
    command     => "$command; echo $command >> /var/lib/irods/.puppet_iadmin.log",
    unless      => $exec_check
  }

}
