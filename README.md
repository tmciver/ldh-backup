# LDH Backup

This project contains a script that can be used to back up the data in a
[LinkedDataHub](https://atomgraph.com/products/linkeddatahub/) (LDH) ([github
project](https://github.com/AtomGraph/LinkedDataHub)) instance.

## Prerequisites

Ensure that the following are satisfied:

* you must have access to the host running LDH and
* the triplestore (Fuseki) must be accessible on the host

If you're running LDH using `docker-compose`, Fuseki will not be exposed to the
host by default.  To expose it, you can use a `docker-compose.override.yml` file
alongside the `docker-compose.yml` file.  Make a copy of
[docker-compose.debug.yml](https://github.com/AtomGraph/LinkedDataHub/blob/db0b49ec0f6b9a650382ece05e731c0b1b17c3b1/docker-compose.debug.yml)
and rename it with:

    $ cp docker-compose.debug.yml docker-compose.override.yml

Edit the file to expose the port for the `fuseki-end-user` service.  You should
have a section like the following:

```
fuseki-end-user:
    ports:
      - 3030:3030
```

Start the system as usual with `docker-compose up -d` and Fuseki's port should
now be exposed to the host.

## Running

The backup script accepts the following parameters:

* `-h`, `--host` - The host name or IP of the LDH instance. Defaults to localhost.
* `-p`, `--port` - The port that Fuseki is available on. Defaults to 3030.
* `-d`, `--ldh-dir` - The base directory of the LDH project.
* `-b`, `--backup-dir` - The directory in which you'd like the backup data stored.

The backup command should look something like:

```
$ ./backup.sh \
  --host localhost \
  --port 3030 \
  --ldh-dir /path/to/linked-data-hub \
  --backup-dir /path/to/ldh/backups
```

You can run the script as frequently as you like; the zipped file containing the
triplestore data is timestamped with minute resolution.
