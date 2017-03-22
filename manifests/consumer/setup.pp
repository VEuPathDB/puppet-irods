# Run vendor's irods_setup.sh for a consumer server
class irods::consumer::setup {
  irods::lib::setup{'consumer':
    setup_rsp_file => 'consumer-setup.rsp',
    setup_rsp_tmpl => 'consumer-setup.rsp.erb',
  }
}
