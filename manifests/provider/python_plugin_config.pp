# Mange the python plugin config in /etc/irods/server_config.json
class irods::provider::python_plugin_config {
  include ::irods::params

  $server_config_json = $::irods::params::server_config_json
  $path = "/files/${server_config_json}/dict/entry[.= 'plugin_configuration']/dict/entry[.= 'rule_engines']/array"

  augeas { "python_plugin":
    incl    => $server_config_json,
    lens    => "Json.lns",
    changes => [
      "set ${path}/dict[last()+1]/entry[1] instance_name",
      "set ${path}/dict[last()]/entry[1]/string irods_rule_engine_plugin-python-instance",
      "set ${path}/dict[last()]/entry[2] plugin_name",
      "set ${path}/dict[last()]/entry[2]/string irods_rule_engine_plugin-python",
      "set ${path}/dict[last()]/entry[3] plugin_specific_configuration",
      "set ${path}/dict[last()]/entry[3]/dict '' ",
  ],
    onlyif => "match ${path}/dict/entry[.= 'instance_name']/string[.= 'irods_rule_engine_plugin-python-instance'] size < 1"
  }
}

