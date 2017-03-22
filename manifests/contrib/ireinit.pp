# Install a custom script to init an iRODS session environment.
# It's a substitute for the stock `iinit` script but this one
# does not prompt for provider host, ports, etc.
class irods::contrib::ireinit {

  file { '/usr/local/bin/ireinit':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/irods/ireinit',
  }

  file { '/etc/ireinit.env':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('irods/ireinit.env.erb'),
  }

}
