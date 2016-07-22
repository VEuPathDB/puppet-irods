# atg groupName userName[#userZone] (add to group - add a user to a group)
# For remote-zone users, include the userZone.
# Also see mkgroup, rfg and rmgroup.
# In addition to the 'rodsadmin', users of type 'groupadmin' can atg and rfg
# for groups they are members of.  They can see group membership via iuserinfo.
#

define irods::lib::icommands::atg (
  String $group = undef,
  String $user  = undef,
) {

  $command = "iadmin atg ${group} ${user}"
  $zone    = $::irods::globals::icat_server_zone

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    unless      => "iadmin lg ${group} |grep -q '^${user}#${zone}'",
  }

}
