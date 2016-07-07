# Mange the re_rulebase_set in /etc/irods/server_config.json
class irods::icat::re_rulebase_set {
  include ::irods::params

  $re_rulebase_set = $::irods::icat::re_rulebase_set
  $server_config_json = $::irods::params::server_config_json

  $augeas_set_template = @(END)
  rm  dict/entry[.= 're_rulebase_set']/array/dict
  <% if @re_rulebase_set and not @re_rulebase_set.empty? %>
    <% @re_rulebase_set.each_with_index do |value, ar_idx| %>
      <% dict_idx = ar_idx +1 %>
      set dict/entry[.= 're_rulebase_set']/array/dict[<%= dict_idx %>]/entry 'filename'
      set dict/entry[.= 're_rulebase_set']/array/dict[<%= dict_idx %>]/entry/string <%= value %>
    <% end %>
  <% end %>
END

  augeas { "re_rulebase_set":
    incl    => $server_config_json,
    lens    => 'Json.lns',
    changes => inline_template($augeas_set_template),
    notify  => Service['irods'],
  }

}