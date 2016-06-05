class irods::icat::setup {
  irods::lib::setup{'icat':
    setup_rsp_file => 'ies-setup.rsp',
    setup_rsp_tmpl => 'ies-setup.rsp.erb',
  }
}
