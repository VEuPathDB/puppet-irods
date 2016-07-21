# Take list of hashes of iRODS iadmin command and parameters. For each
# 'exec' key add a define type for that key value to the catalog and set
# 'require' dependency on the previous resource created.
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