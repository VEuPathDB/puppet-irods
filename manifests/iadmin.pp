

define irods::iadmin (
  $exec = undef,
  $args = undef,
) {

 notify{ "IADMIN ,,, ${exec} ... ${args}":}
#  irods::lib::iadmin::${exec} {
#    args => $args,
#  }

}