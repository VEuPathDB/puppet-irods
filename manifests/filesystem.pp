
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