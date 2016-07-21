# addchildtoresc Parent Child [ContextString] (add child to resource)
# Add a child resource to a parent resource.  This creates an 'edge'
# between two nodes in a resource tree.
# 
# Parent is the name of the parent resource.
# Child is the name of the child resource.
# ContextString is any relevant information that the parent may need in order
# to manage the child.
#
define irods::lib::icommands::addchildtoresc (
  $resc = undef,
  $chld = undef,
) {

  $command = "iadmin addchildtoresc ${resc} ${chld}"

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    unless      => "iadmin lr ${chld} |grep -q 'resc_parent: ${resc}'",
  }

}
