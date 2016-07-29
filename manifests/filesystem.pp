# Obsolete, I think. The intent was to  create the
# unix directory for a resource, but iRODS will do that.
class irods::filesystem (
  $paths = []
) {

  $paths.each |$path| {
    file { $path:
      ensure => 'directory',
      owner  => $irods::globals::srv_acct,
      group  => $irods::globals::srv_grp,
      mode   => '0750',
    }
  }

}