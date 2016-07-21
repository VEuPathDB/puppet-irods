## Usage

Use one and only one of the following classes per server.

    include irods::icat

    include irods::resource

    include irods::client

Deploying the iCAT server will also include resource and icommand
components, and the resource server includes icommands, so there is no
need to include more than one class on a node.

## Database Prerequisite

This module runs stock iRODS setup scripts that populates a pre-existing
iCAT database with schema and data. This module does **not** create the
iCAT database. You will need to ensure that the database is created (say
in your own puppet profile manifest) before calling classes in this
module. When you create the database, ensure it is compatible with the
values set for this module's `irods::icat::db_vendor`,
`irods::icat::db_name`, `irods::icat::db_user` and
`irods::icat::db_password` parameters.

## Limitations

- Only the RedHat OS family is supported at this time.

- The [binary distribution packages](http://irods.org/download/) must be
in an apt/yum repository; this module does not support installing
packages from RENCI's FTP server because it's too difficult for Puppet
to manage package dependencies. I believe RENCI is working on yum/apt
repositories as part of the 4.2 release. In the meantime, you are on
your own creating a repo and configuring the server to use it.

- The RPM packages for irods-icommands, irods-icat and irods-resource each
contain icommand executables so only one can be installed on a server
(rpm complains of conflicting files if you try to install more that noe
package). Same for database plugins - only one at a time.

- This module does not manage firewall ports used by iRODS.

- You will need to deploy your iCAT server first because the resource server setup scripts
requires a functional iCAT server for resource registration and testing.

## Example Hiera

Hiera is recommended for setting parameter values. The parameters in
this example are the most important ones to tailor for your
infrastructure.

    irods::globals::icat_server: ies.irods.vm
    irods::globals::icat_server_zone: ebrc
    irods::globals::icat_admin_user: rods
    irods::globals::icat_admin_pass: rods
    irods::globals::srv_negotiation_key: fbb4c4fd185e3a98f8715ff5c1c86715
    irods::globals::ctrl_plane_key: ca2ad0abf0faa703cf0829af99465ac9
    irods::globals::srv_zone_key: e83ac54fe6d5d66f24d16644ce72d9ae

    irods::icat::db_vendor: postgres
    irods::icat::db_name: ICAT
    irods::icat::db_password: passWORD
    irods::icat::db_srv_host: localhost

## Parameters

Component-specific parameters are distributed among `irods::icat`,
`irods::resource`, `irods::client` namespaces. Parameters that need to
be shared among two or more components are defined in the
`irods::globals` namespace.

_Parameter descriptions in italics are copied from the tutorial
"[Getting Started with iRODS
4.1](http://irods.org/wp-content/uploads/2015/06/GettingStartedwiRODS4.1
.pdf)"._

### irods::globals namespace parameters

#### `irods::globals::ctrl_plane_key`

_A secret key shared by all servers._

You should set this because the default is not a secret. It must be
exactly 32 bytes. One method for generating a random 32-byte string is
with the command

    openssl rand -hex 16

#### `irods::globals::ctrl_plane_port`

_The port used for the control plane. The control plane receives status
updates from all servers, and issues commands to servers to pause,
resume, shut down, etc._

#### `irods::globals::default_vault_dir`

_The Vault (i.e., storage) location of the default unixfilesystem
resource created during installation._

#### `irods::globals::icat_admin_pass`

The password for the iRODS administration account
(`irods::globals::icat_admin_user`). You should set this because the
default is not a secret.

#### `irods::globals::icat_admin_user`

The name of the administration account used to manage iRODS through
icommands and related. It will be created in the iRODS catalog during
setup.

#### `irods::globals::icat_server`

The hostname where the iRODS resource components and icommands can find
the iCAT server. You almost certainly want set this. The default is
`localhost`.

#### `irods::globals::icat_server_zone`

_The name of the iRODS zone._

The default is `tempZone`. You probably will want to change this.

#### `irods::globals::schema_base_uri`

_The location of the schema files used to validate the server's configuration files._

Typically you should use the default
`https://schemas.irods.org/configuration`.

#### `irods::globals::srv_acct`

_The Linux account that will run the iRODS server software. The account
will be created if it does not already exist._

This applies to iCAT and resource servers. The default is `irods`.

#### `irods::globals::srv_grp`

_The primary group of the Linux account that will run the iRODS server
software._

This applies to iCAT and resource servers. The default is `irods`.

#### `irods::globals::srv_negotiation_key`

_A secret key used in server-to-server communication._

You should set this because the default is not a secret. It must be
exactly 32 bytes. One method for generating a random 32-byte string is
with the command

    openssl rand -hex 16

#### `irods::globals::srv_port`

_The main iRODS port._

The default is 1247.

#### `irods::globals::srv_port_range_end`

_The end of the port range used when transferring large files._

The default is `20199`.

#### `irods::globals::srv_port_range_start`

_The beginning of the port range used when transferring large files._

The default is `2000`.

#### `irods::globals::srv_zone_key`

_A secret key used in server-to-server communication._

You should set this because the default is not a secret. It must be
exactly 32 bytes. One method for generating a random 32-byte string is
with the command

    openssl rand -hex 16

#### `irods::globals::core_version`

Not implemented. This module will install the most recent version
found in the YUM repo. It does not do any subsequent updates from new
versions added to the repo.

### irods::icat namespace parameters

#### `irods::icat::core_version`

Not implemented. This module will install the most recent version found
in the YUM repo. It does not do any subsequent updates from new versions
added to the repo.

#### `irods::icat::db_vendor`

One of 'postgres', 'oracle', 'mysql'. This determines which database
plugin to install. The default is 'postgres'.

#### `irods::icat::db_name`

The name of the iCAT database. The default is `ICAT`.

#### `irods::icat::db_user`

The database user for connects to the iCAT database.

This may need to match the irods Linux account name
(`irods::globals::srv_acct`) to authenticate into Postgres without
changing Postgres settings.

The default is the value of `irods::globals::srv_acct`.

#### `irods::icat::db_password`

The password for the database user that iRODS uses to connect to the
iCAT database. You should set this because the default is not a secret.

#### `irods::icat::db_srv_host`

Host of the ICAT database. For example,

  - fully qualified domain name
  - localhost
  - 127.0.0.1

The default is `localhost` and that should be
sufficient if the database and iCAT software are colocated on the same
server.

Be aware that for some databases connecting to `localhost` will attempt
to use a Unix-domain socket and `127.0.0.1` will use a TCP port.
Therefore pay attention that your database configurations allow
connections for your chosen host. See the Tips section for guidance when
using Postgres for the ICAT database.

#### `irods::icat::db_srv_port`

The port that the database listens for user connections. The
default is PostgreSQL's port `5432`.

#### `irods::icat::do_setup`

**This is currently required to be true. Several file dependencies will
not be satisifed if set to false.**

true or false. The default is `true`. This determines whether to run the
irods setup script. If `true` the setup script will run when iRODS
packages are installed.

If you want setup to run after database or other changes, you can do
manage that in your profile, with something like

        if $irods::icat::do_setup == true {
          include irods::lib::setup
          Postgresql::Server::Db[$irods::icat::db_name] ~>
          Class['irods::lib::setup']
        }

will trigger setup to run after a password change. I do not know the
safety of running setup on an existing production instance, so be
cautious.

#### `irods::icat::re_rulebase_set`

An ordered array of values for `re_rulebase_set` in `/etc/irods/server_config.json`.

The default is `['core']`. The `re_rulebase_set` is generated from this
array so you should typically include `'core'`.

You are responsible for ensuring the rulebase file is installed to
`/etc/irods` (I believe it is ok to install after iCAT is installed, so
the `/etc/irods` directory will exist).

### irods::resource namespace parameters

#### `irods::resource::do_setup`

See the description for `irods::icat::do_setup`.

### irods::client namespace parameters

None

## Tips

#### Manually running iRODS setup.

This module generates a response file that can be fed to the iRODS setup
script in the event that you want to run setup manually.

Before running setup, delete the `service_account.config` file if it exists.

    rm /etc/irods/service_account.config

Then run `setup_irods.sh` with the response file on the iCAT server

    /var/lib/irods/packaging/setup_irods.sh < /var/lib/irods/.puppetstaging/ies-setup.rsp

or with the response file on the resource server

    /var/lib/irods/packaging/setup_irods.sh < /var/lib/irods/.puppetstaging/rs-setup.rsp

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

## SSL Setup

#### `irods::lib::ssl` 

Create SSL certificates signed by a third-party or internal CA.
Self-signed certificates are not supported. Declare the
`irods::lib::ssl` defined type with `ssl_certificate_chain_file_source`
and `ssl_certificate_key_file_source` parameters.

      irods::lib::ssl { 'resource':
        ssl_certificate_chain_file_source =>
          "puppet:///modules/profiles/ssl/${hostname}-rsa.crt",
        ssl_certificate_key_file_source   =>
          "puppet:///modules/profiles/ssl/${hostname}-rsa.key",
      }

You will want to make sure the CA is installed on the system, especially
if using an internal CA. For example, puppet module
`jlambert121/trusted_ca` is useful for managing that.

## PAM Setup

Configuring iRODS to use PAM depends on your specific environment. For
example, do you want to use /etc/passwd or LDAP? In the case of LDAP,
there are dependencies on how your directory is configured and whether
you want to use LDAP only for iRODS or also for system logins.
Therefore, this module does not attempt any PAM configuration.

## iAdmin commands

Experimental support for running `iadmin` commands is partially
implemented. You probably do not want Puppet managing resources in
production environments but it can be handy for virtualized
development/testing environments.

### Usage

The desired iadmin commands are specified in the hiera `irods::icommands`
array of hashes. Each hash must have an `exec` key for the iadmin
subcommand. Additional keys are provided as specific arguments for the
subcommand. The iadmin commands are invoked in array order. The `exec`
key maps to a Puppet define type in the `irods::lib::icommands` namespace
that controls the iadmin command. For example, `exec: mkresc` maps to
the `irods::lib::icommands::mkresc` Puppet define type. The subcommand
argument keys must match the parameter names in the define type.

    irods::icommands:
      - exec: mkresc
        resc: data_7k_001
        type: unixfilesystem
        path: rs1.vm:/srv/irods/vault_7k_001
      - exec: mkresc
        resc: data_7k_002
        type: unixfilesystem
        path: rs1.vm:/srv/irods/vault_7k_002
      - exec: mkresc
        resc: data
        type: roundrobin
      - exec: addchildtoresc
        resc: data
        chld: data_7k_001
      - exec: addchildtoresc
        resc: data
        chld: data_7k_002

The filesystem paths are not created on the resource server. You will
need to use other means to ensure those exist with correct permissions.
See `irods::filesystem` for one option.

Note that the commands are executed in order, as is. There is no attempt
to manage the full consistency of resources. That is, for example, if
you were to change the name of the `data` resource to `dataResc` in the
above example, the Puppet module will not be smart enough to remove
`data_7k_001` from `data` and then add it to `dataResc`. It will
silently fail to `addchildtoresc dataResc data_7k_001`, because
`data_7k_001` is already a child of `data`, unless you manually
`rmchildfromresc` ahead of time.

### Writing new iadmin define types

Not all iadmin subcommands have been implemented so you will need to
write a new Puppet define type for any missing support that you need.
See existing define types in the `irods::lib::icommands` namespace for
model examples.

The `irods::icommands` class includes resources to log in as the admin user
(the one defined for `irods::globals::icat_admin_user`).

Be sure to explicitly set the `HOME` environment variable to the directory where the
`.irods/irods_environment.json` is located.

    ...
    environment => ["HOME=/root"],
    ...

## irods::filesystem

The `irods::filesystem` class can be used to manage filesystem paths
that back irods resources. This is not required; you can manage your
backing stores anyway you want. The class takes a `paths` parameter that
is an array of POSIX file paths. In hiera that could look like,

    irods::filesystem::paths:
      - /srv/irods
      - /srv/irods/vault_7k_001
      - /srv/irods/vault_7k_002

(note the `/srv/irods` parent directory is also included to satisfy Puppet prerequisites).

