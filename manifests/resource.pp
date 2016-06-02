# installs resource server
class irods::resource (
  $version = $irods::params::version,
) inherits irods::params {

  irods::install { 'irods-resource':
    packages => ['irods-resource', 'fuse-libs'],
    version  => $version,
  }

}
