# Run vendor's irods_setup.sh for the iCAT-enabled server
class irods::icat::setup {
  if $::irods::icat::do_setup {
    notify{"Doing iRODS setup":}
    irods::lib::setup{'icat':
      setup_rsp_file => 'ies-setup.rsp',
      setup_rsp_tmpl => 'ies-setup.rsp.erb',
    }
  } else {
    notify{"Skipping iRODS setup":}
  }
}
