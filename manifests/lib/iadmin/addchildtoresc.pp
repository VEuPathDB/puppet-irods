
define irods::lib::iadmin::addchildtoresc (
  $resc = undef,
  $chld = undef,
) {

  $command = "iadmin addchildtoresc ${resc} ${chld}"

  exec { $name:
    path        => '/usr/bin',
    environment => ["HOME=/root"],
    command     => "$command; echo $command >> /var/lib/irods/.puppet_iadmin.log",
    unless      => "iadmin lr ${chld} |grep -q 'resc_parent: ${resc}'"
  }

}
