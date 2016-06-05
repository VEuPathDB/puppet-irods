## Usage

Use one and only one of the following classes per server.

    include irods::icat

    include irods::resource

    include irods::icommands

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

## Parameters

Component-specific parameters are distributed among `irods::icat`,
`irods::resource`, `irods::icommands` namespaces. Parameters that need to
be shared among two or more components are defined in the
`irods::globals` namespace.

_Parameter descriptions in italics are copied from the tutorial
"[Getting Started with iRODS
4.1](http://irods.org/wp-content/uploads/2015/06/GettingStartedwiRODS4.1
.pdf)"._

### irods::globals namespace parameters

#### `irods::globals::ctrl_plane_key`

_A secret key shared by all servers._

You should set this because the default is not a secret.

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

You should set this because the default is not a secret.

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

You should set this because the default is not a secret.

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

### irods::resource namespace parameters

#### `irods::resource::do_setup`

See the description for `irods::icat::do_setup`.

### irods::icommands namespace parameters

None

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

