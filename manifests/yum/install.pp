# install from YUM
# This is incomplete. RENCI does not yet have relevant packages
# in the repo (as of June 1, 2016)
class irods::yum::install {
  $gpg_key_path =  '/etc/pki/rpm-gpg/RPM-GPG-KEY-RENCI-IRODS'

  file { '/etc/yum.repos.d/renci-irods.repo':
    source => 'https://packages.irods.org/renci-irods.yum.repo',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { $gpg_key_path:
    source => 'https://packages.irods.org/irods-signing-key.asc',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # pilfered from epel::rpm_gpg_key 
  exec {  "import-${gpg_key_path}":
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    command   => "rpm --import ${gpg_key_path}",
    unless    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids --keyid-format short < ${gpg_key_path}) | cut --characters=11-18 | tr '[A-Z]' '[a-z]')",
    require   => File[$gpg_key_path],
    logoutput => 'on_failure',
  }

}