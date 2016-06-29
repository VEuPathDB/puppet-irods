
class irods::service {

  service { 'irods':
    ensure => 'running',
  }
}