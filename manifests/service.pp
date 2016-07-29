# manage irods service
class irods::service {

  service { 'irods':
    ensure => 'running',
  }
}