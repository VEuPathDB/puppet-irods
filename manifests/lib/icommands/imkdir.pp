#
#   Usage: imkdir [-phvV] collection ...
#   Create one or more new collections
#   Options are:
#    -p  make parent directories as needed
#    -v  verbose
#    -V  Very verbose
#    -h  this help

define irods::lib::icommands::imkdir (
  String        $collection = '',
  Enum[
    '',
    '-p',
    '-v',
    '-V'
  ]              $option    = '',
) {

  # ensure no trailing slash
  $ncoll = regsubst($collection, '/+$', '')

  $command = "imkdir ${option} ${ncoll}"

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    onlyif      => "ils ${ncoll} 2>&1 | grep -q 'does not exist'",
  }

}