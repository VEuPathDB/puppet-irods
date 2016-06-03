The irods-icommands (irods::client), irods-icat (irods::icat) and
irods-resource (irods::resource) duplicate files so can not be installed
on same server. Same for database plugins - only one at a time

## Limitations

Only RedHat family is supported at this time.

The [binary distribution packages](http://irods.org/download/) must be
in an apt/yum repository; this module does not support installing
packages from RENCI's FTP server because it's too difficult to manage
dependencies in Puppet. I believe RENCI is working on yum/apt
repositories as part of the 4.2 release. In the meantime, you are on
your own creating a repo and configuring the server to use it.




## Parameters

Component-specific parameters are distributed among `irods::icat`,
`irods::resource`, `irods::client` namespaces. Parameters that need to
be shared among two or more components are defined in the
`irods::globals` namespace.

### irods::globals

#### irods::globals::srv_zone_key


### irods::icat

#### irods::icat::core_version

Not implemented.

#### irods::icat::db_plugin_version

Not implemented.

#### irods::icat::db_vendor

One of 'postgres', 'oracle', 'mysql'. This determines which database
plugin to install. The default is 'postgres'.
