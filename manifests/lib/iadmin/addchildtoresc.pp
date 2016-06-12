
class irods::lib::iadmin::addchildtoresc (
  $resc = undef,
  $type = undef,
  $path = undef,
  $ctxs = undef,
) {

  exec { "${resc}_${type}_${path}_${ctxs}":
    path    => '/usr/bin',
    command => "iadmin addchildtoresc $resc type $path $ctxs",
    onlyif  => "iadmin lr ${resc} |grep -q 'No rows found'"
  }

}
