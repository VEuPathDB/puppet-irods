
define irods::lib::iadmin::addchildtoresc (
  $resc = undef,
  $chld = undef,
) {

  notify{"IADMIN iadmin addchildtoresc ${resc} ${chld}": }
  notify{"IADMIN iadmin lr ${chld} |grep -q 'resc_parent: ${resc}'": }

  exec { $name:
    path        => '/usr/bin',
    environment => ["HOME=/root"],
    command     => "iadmin addchildtoresc ${resc} ${chld}",
    unless      => "iadmin lr ${chld} |grep -q 'resc_parent: ${resc}'"
  }

}
