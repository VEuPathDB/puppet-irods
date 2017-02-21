# Take list of hashes of iRODS iadmin command and parameters. For each
# 'exec' key add a define type for that key value to the catalog and set
# 'require' dependency on the previous resource created.
#
# For example, hiera data
#     irods::icommands:
#       - { exec: mkresc, resc: ebrcResc, type: passthru }
#       - { exec: mkresc, resc: rr1Resc, type: roundrobin }
#
# In manifest
#      $iadmin_set = hiera_array('irods::icommands', [])
#      iadmin_collect($iadmin_set)
#
# dynamically generates the equivalent of
#
#     irods::lib::icommands::mkresc { 'mkresc_ebrcResc_passthru':
#
#     }
#     irods::lib::icommands::mkresc { 'mkresc_rr1Resc_roundrobin':
#       require => Irods::Lib::Icommands::Mkresc['mkresc_ebrcResc_passthru']
#     }
#
# The defined type, 'irods::lib::icommands::mkresc' in this example, must
# exist.
#
module Puppet::Parser::Functions
  newfunction(:iadmin_collect) do |args|
    exec_set = args[0]

    previous_resource = nil

    exec_set.each do |entry|

      type_name = 'irods::lib::icommands::' + entry['exec']
      resource = find_definition(type_name.downcase)
      title = entry.values.join('_')
      entry.delete('exec')

      p_resource = Puppet::Parser::Resource.new(
        type_name,
        title,
        :scope => self,
        :source => resource
      )

      {:name => title, :require => previous_resource}.merge(entry).each do |k,v|
        p_resource.set_parameter(k,v)
      end

      resource.instantiate_resource(self, p_resource)
      compiler.add_resource(self, p_resource)

      previous_resource = p_resource
    end
  end
end