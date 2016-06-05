# Class for setting cross-class global overrides.
# Hiera,
#       irods::globals::admin_password
class irods::globals (
  $ctrl_plane_key       = 'TEMPORARY__32byte_ctrl_plane_key',
  $ctrl_plane_port      = '1248',
  $default_vault_dir    = '/var/lib/irods/iRODS/Vault',
  $icat_admin_pass      = 'rods',
  $icat_admin_user      = 'rods',
  $icat_server          = 'localhost',
  $icat_server_zone     = 'tempZone',
  $schema_base_uri      = 'https://schemas.irods.org/configuration',
  $srv_acct             = 'rods',                                       # file, process owner
  $srv_grp              = 'rods',                                       # file, process group
  $srv_negotiation_key  = 'TEMPORARY_32byte_negotiation_key',
  $srv_port             = '1247',
  $srv_port_range_end   = '20199',
  $srv_port_range_start = '20000',
  $srv_zone_key         = 'TEMPORARY_zone_key',
  $core_version         = 'installed' # support for specific version not implemented.
) {

  include irods::contrib::ireinit

}
