# Run vendor's irods_setup.sh for a resource server
class irods::resource::setup {
  irods::lib::setup{'resource':
    setup_rsp_file => 'resource-setup.rsp',
    setup_rsp_tmpl => 'resource-setup.rsp.erb',
  }
}
