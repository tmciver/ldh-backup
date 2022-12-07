# LDH Backup

This project contains a script that can be used to back up the data in a
[LinkedDataHub](https://atomgraph.com/products/linkeddatahub/) (LDH) ([github
project](https://github.com/AtomGraph/LinkedDataHub)) instance.

## Prerequisites

Ensure that the following are satisfied:

* you must have access to the host running LDH and
* the triplestores (Fuseki) must be accessible on the host

If you're running LDH using `docker-compose`, the two Fuseki triplestores will
not be exposed to the host by default.  To expose them, you can use a
`docker-compose.override.yml` file alongside the `docker-compose.yml` file.
Make a copy of
[docker-compose.debug.yml](https://github.com/AtomGraph/LinkedDataHub/blob/db0b49ec0f6b9a650382ece05e731c0b1b17c3b1/docker-compose.debug.yml)
and rename it with:

    $ cp docker-compose.debug.yml docker-compose.override.yml

This file may already contain the necessary port mappings but you should ensure
that is data like the following:

```
fuseki-admin:
    ports:
      - 3030:3030
fuseki-end-user:
    ports:
      - 3031:3030
```

Start the system as usual with `docker-compose up -d` and Fuseki's ports should
now be exposed to the host.

## Running

### Backing Up

The backup script accepts the following parameters:

* `-h`, `--host` - The host name or IP of the LDH instance. Defaults to localhost.
* `-p`, `--user-port` - The port that Fuseki end user data is available on. Defaults to 3031.
* `-p`, `--admin-port` - The port that Fuseki admin data is available on. Defaults to 3030.
* `-l`, `--ldh-dir` - The base directory of the LDH project.
* `-b`, `--backup-dir` - The directory in which you'd like the backup data stored.
* `-d`, `--data-source` - The name of the Fuseki data source. Defaults to "ds".

The backup command should look something like:

```
$ ./backup.sh \
  --host localhost \
  --admin-port 3030 \
  --user-port 3031 \
  --ldh-dir /path/to/linked-data-hub \
  --backup-dir /path/to/ldh/backups
```

You can run the script as frequently as you like; the zipped file containing the
triplestore data is timestamped with minute resolution.

### Restoring

The restore script accepts the following parameters:

* `-h`, `--host` - The host name or IP of the LDH instance. Defaults to localhost.
* `-p`, `--user-port` - The port that Fuseki end user data is available on. Defaults to 3031.
* `-p`, `--admin-port` - The port that Fuseki admin data is available on. Defaults to 3030.
* `-l`, `--ldh-dir` - The base directory of the LDH project.
* `-b`, `--backup-dir` - The directory in which you'd like the backup data stored.
* `-d`, `--data-source` - The name of the Fuseki data source. Defaults to "ds".
* `-t`, `--timestamp` - The timestamp of the backup to restore.

The restore command should look something like:

```
$ ./restore.sh \
  --host localhost \
  --admin-port 3030 \
  --user-port 3031 \
  --ldh-dir /path/to/linked-data-hub \
  --backup-dir /path/to/ldh/backups \
  --timestamp 202212020934
```

Note that this operation will overwrite the existing user and admin triples so
be sure to back up any not-yet-backed-up data first if you don't want to lose
it.
