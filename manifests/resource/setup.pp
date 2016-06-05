class irods::resource::setup {
  irods::lib::setup{'resource':
    setup_rsp_file => 'resource-setup.rsp',
    setup_rsp_tmpl => 'resource-setup.rsp.erb',
  }
}
