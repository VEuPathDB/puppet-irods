# Add child to resource.
#
# Usage
#   addchildtoresc Parent Child [ContextString]
#
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
  $ctxs = undef,
) {

  $command = "iadmin addchildtoresc ${resc} ${chld} $ctxs"

  $exec_check = "iadmin lr ${chld} |grep  \"resc_parent: $(iadmin lr ${resc} | grep resc_id: | cut -d' ' -f2)$\""

  exec { $name:
    path        => '/usr/bin',
    environment => ['HOME=/root'],
    command     => "${command}; echo ${command} >> /var/lib/irods/.puppet_icommands.log",
    unless      => $exec_check,
  }
}
