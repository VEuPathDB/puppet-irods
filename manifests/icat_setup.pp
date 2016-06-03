class irods::icat_setup {
  irods::setup{'icat':
    setup_rsp_file => 'ies-setup.rsp',
    setup_rsp_tmpl => 'ies-setup.rsp.erb',
  }
}
