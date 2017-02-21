# manage irods service
#
# iRODS started by `irodsctl` (as is the case when setup.py is run) is
# not detected by systemd. So we monkey patch the Service{} start
# parameter to ensure `irodsctl` is stopped before starting with systemd.
#
class irods::service {

  include irods::globals

  $irodsctl_stop = "su irods -c '${::irods::globals::irods_home}/irodsctl stop' 2>&1"

  service { 'irods':
    ensure => 'running',
    start  => "${irodsctl_stop} && systemctl start irods",
    stop   => "${irodsctl_stop} && systemctl stop irods",
  }
}