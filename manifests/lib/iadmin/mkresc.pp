
define irods::lib::iadmin::mkresc (
  $resc = undef,
  $type = undef,
  $path = undef,
  $ctxs = undef,
) {

  $command = "iadmin mkresc ${resc} ${type} ${path} ${ctxs}"

  exec { $name:
    path    => '/usr/bin',
    environment => ["HOME=/root"],
    command => "$command; echo $command >> /var/lib/irods/.puppet_iadmin.log",
    onlyif  => "iadmin lr ${resc} |grep -q 'No rows found'"
 }

}
