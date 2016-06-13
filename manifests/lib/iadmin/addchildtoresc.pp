
define irods::lib::iadmin::addchildtoresc (
  $resc = undef,
  $chld = undef,
) {

  exec { $name:
    path        => '/usr/bin',
    environment => ["HOME=/root"],
    command     => "iadmin addchildtoresc ${resc} ${chld}",
    unless      => "iadmin lr ${chld} |grep -q 'resc_parent: ${resc}'"
  }

}
