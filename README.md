## Usage

    include irods::icat

    include irods::resource

    include irods::icommands



The irods-icommands (irods::icommands), irods-icat (irods::icat) and
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

This module does not manage firewall ports used by iRODS.

Resource server setup requires an available, functional iCAT server. So
construct your Puppet manifests accordingly.

## Parameters

Component-specific parameters are distributed among `irods::icat`,
`irods::resource`, `irods::icommands` namespaces. Parameters that need to
be shared among two or more components are defined in the
`irods::globals` namespace.

### irods::globals

#### irods::globals::srv_zone_key

#### irods::globals::icat_server

You must set this. The default is `localhost`.

### irods::icat

#### irods::icat::do_setup

true or false. The default is true. Whether to run the irods setup
script. If true the setup script will run when iRODS packages are installed.

If you want setup to run after database or other changes, you can do
manage that in your profile, something like

        if $irods::icat::do_setup == true {
          include irods::lib::setup
          Postgresql::Server::Db[$irods::icat::db_name] ~>
          Class['irods::lib::setup']
        }

will trigger setup to run after a password change. I do not know the
safety of running setup on an existing production instance, so be
cautious.

#### irods::icat::core_version

Not implemented.

#### irods::icat::db_plugin_version

Not implemented.

#### irods::icat::db_vendor

One of 'postgres', 'oracle', 'mysql'. This determines which database
plugin to install. The default is 'postgres'.


#### irods::icat::db_srv_host

Host of the ICAT database.

For example,
  - fully qualified domain name 
  - localhost
  - 127.0.0.1

Be aware that for some databases connecting to `localhost` will attempt
to use a Unix-domain socket and `127.0.0.1` will use a TCP port.
Therefore pay attention that your database configurations allow
connections for your chosen host. See the Tips section for guidance when
using Postgres for the ICAT database.

## Tips

#### Postgres and `irods::icat::db_srv_host`

If you use `localhost` with Postgres, you may need to create a `local`
rule (for Unix-domain sockets) in `/var/lib/pgsql/data/pg_hba.conf` with
`md5` auth method, and that needs to come before any other `local`
entries in the file. For example,

        local   ICAT    irods           md5
        local   all     all             ident
  
A symptom of misconfiguration is the error

        Database [ICAT] on [localhost] cannot be found.
        psql: FATAL:  Peer authentication failed for user "irods"

when running the `setup_irods.sh` script or when connecting with psql
  
       PGPASSWORD='irodspassword'  psql --username=irods ICAT

If you are using `puppetlabs-postgres` module, you can create a rule like,

       postgresql::server::pg_hba_rule {'irods access to local socket':
          type        => 'local',
          database    => $irods::icat::db_name,
          user        => $irods::icat::db_user,
          auth_method => 'md5',
          order       => '001',
        }

