# Class for setting cross-class global overrides.
#
class irods::globals (
  $ctrl_plane_key                    = 'TEMPORARY__32byte_ctrl_plane_key',
  $ctrl_plane_port                   = '1248',
  $irods_home                        = '/var/lib/irods',
  $default_vault_dir                 = '/var/lib/irods/Vault',
  $provider_admin_pass                   = 'rods',
  $provider_admin_user                   = 'rods',
  $provider_server                       = 'localhost',
  $provider_server_zone                  = 'tempZone',
  $schema_base_uri                   = 'file:///var/lib/irods/configuration_schemas',
  $srv_acct                          = 'irods',                                       # file & process owner
  $srv_grp                           = 'irods',                                       # file & process group
  $srv_negotiation_key               = 'TEMPORARY_32byte_negotiation_key',
  $srv_port                          = '1247',
  $srv_port_range_start              = '20000',
  $srv_port_range_end                = '20199',
  $srv_zone_key                      = 'TEMPORARY_zone_key',
  $use_ssl                           = false,
  $ssl_certificate_chain_file_source = '',
  $ssl_certificate_key_file_source   = '',
  $core_version                      = '4.2.0',
  $install_dev_pkgs                  = true,
) {

  include ::irods::contrib::ireinit

}
