
define irods::lib::iadmin::mkresc (
  $resc = undef,
  $type = undef,
  $path = undef,
  $ctxs = undef,
) {

 exec { $name:
   path    => '/usr/bin',
   command => "iadmin mkresc ${resc} type ${path} ${ctxs}",
   onlyif  => "iadmin lr ${resc} |grep -q 'No rows found'"
 }

}
