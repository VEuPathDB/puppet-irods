module Puppet::Parser::Functions
  newfunction(:iadmin_collect) do |args|
    exec_set = args[0]

    exec_set.each do |entry|

      type_name = 'irods::lib::iadmin::' + entry['exec']
      resource = find_definition(type_name.downcase)
      title = entry.values.join('_')
      entry.delete('exec')

      p_resource = Puppet::Parser::Resource.new(
        type_name,
        title,
        :scope => self,
        :source => resource
      )

      {:name => title}.merge(entry).each do |k,v|
        p_resource.set_parameter(k,v)
      end

      resource.instantiate_resource(self, p_resource)

      compiler.add_resource(self, p_resource)

    end
  end
end