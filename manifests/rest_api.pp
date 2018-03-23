# configure irods rest service via docker

class irods::rest_api (
  # variables for docker
  $rest_image               = 'diceunc/rest:4.1.10.0-RC1',
  $rest_port                = '8180',

  # variables for template
  $irods_host               = 'localhost',
  $irods_port               = '1247',
  $irods_zone               = 'nozone',
  $default_storage_resource = 'noResc',
  $extra_docker_args        = {},

) inherits irods::params {

  include ::docker

  docker::run { 'irods-api':
    image   => "$rest_image",
    ports   => ["$rest_port:8080"],
    volumes => ['/etc/irods-ext:/etc/irods-ext', '/etc/irods/ssl:/tmp/cert'],
    *       => $extra_docker_args,
    require => [ 
      File['/etc/irods-ext/irods-rest.properties'], 
      Class['irods::provider']
    ]
  }

  # rest config
  file {'/etc/irods-ext/':
    ensure => 'directory',
  }

  file {'/etc/irods-ext/irods-rest.properties':
    content => template('irods/irods-rest.properties.erb'),
    notify   => Docker::Run['irods-api'],
  }

}

