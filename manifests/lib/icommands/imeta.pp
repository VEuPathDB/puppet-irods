#
#Usage: imeta [-vVhz] [command]
# -v verbose
# -V Very verbose
# -z Zonename  work with the specified Zone
# -h This help
#Commands are:
# add -d|C|R|u Name AttName AttValue [AttUnits] (Add new AVU triple)
# set -d|C|R|u Name AttName newValue [newUnits] (Assign a single value)
#
# Note: because this is mainly used for setup, only add/set is supported currently

define irods::lib::icommands::imeta (
  Enum[
    'add',
    'set'
  ]                 $action = undef,
  String            $collOrDataObj =  undef,
  Enum[
    '',
    '-v',
    '-V',
    '-z'
  ]                 $option = '',
  Enum[
    '-d',
    '-C',
    '-R',
    '-u'
  ]                 $objtype = '',
  String            $attname = '',
  String            $attvalue = '',
  String            $attunits = ''

) {

  $command = "imeta ${option} ${action} ${objtype} ${collOrDataObj} ${attname} ${attvalue} ${attunits} "

  $zone    = $::irods::globals::provider_server_zone

  case $action {
    'add':   {
      $exec_check = "imeta ls ${objtype} ${collOrDataObj} ${attname} | grep -q 'value: ${attvalue}'"
    }
    'set':   {
      $exec_check = "imeta ls ${objtype} ${collOrDataObj} ${attname} | grep -q 'value: ${attvalue}'"
    }
  }

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    unless      => $exec_check,
  }

}
