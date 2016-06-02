
class irods::params {

  $version = 'latest'

  $core_packages = [
    'irods-icat',
    'irods-resource',
    'irods-icommands',
  ]

  case $::osfamily {
    'RedHat': {
      $os = "centos${::operatingsystemmajrelease}"
      $prefix = "ftp://ftp.renci.org/pub/irods/releases/${version}"
      $icat_pkg = "${prefix}/${os}/irods-icat-${version}-${os}-${::architecture}.rpm"
      $resc_pkg = "${prefix}/${os}/irods-resource-${version}-${os}-${::architecture}.rpm"
      $icmd_pkg = "${prefix}/${os}/irods-icommands-${version}-${os}-${::architecture}.rpm"  
      # oracle plugin NA for EL 7 (June 1, 2016)
      $orcl_pkg = "${prefix}/centos6/irods-database-plugin-oracle-1.8-centos6-${::architecture}.rpm"
    }

    default: {
      fail("Unsupported platform: ${module_name} currently doesn't support ${::operatingsystem}")
    }

  }

}