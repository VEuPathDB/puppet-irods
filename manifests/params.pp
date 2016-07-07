# Default parameters for iCAT or Resource servers. These are meant to be
# overridden in irods::icat or irods::resource classes. See also the
# irods::globals class for parameters that cross icat and resource class
# boundaries.
class irods::params inherits irods::globals {

  $db_vendor         = 'postgres' # or oracle or mysql
  $db_plugin_version = '1.8-0' # not implemented
  $db_name           = 'ICAT'
  $db_user           = $irods::globals::srv_acct
  $db_password       = 'irodspassword'
  $db_srv_host       = 'localhost'
  $db_srv_port       = '5432'

  $do_setup = true

  $re_rulebase_set = ['core']
  $server_config_json = '/etc/irods/server_config.json'

  # Only one icat|resource|icommands package and one database plugin can
  # be installed at a time. See the irods::lib::install define type for how
  # this list is used to ensure one of each is installed and the others
  # are absent. This list is ordered so dependencies are handled first
  # during any uninstallations.
  $core_packages = [
    'irods-database-plugin-mysql',
    'irods-database-plugin-oracle',
    'irods-database-plugin-postgres',
    'irods-icat',
    'irods-resource',
    'irods-icommands',
  ]

  case $::osfamily {
    'RedHat': {
      $os = "centos${::operatingsystemmajrelease}"
    }

    default: {
      fail("Unsupported platform: ${module_name} currently doesn't support ${::operatingsystem}")
    }

  }

}