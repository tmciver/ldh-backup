#!/usr/bin/env bash

ldh_dir="$1"
backup_dir="$2"
host="$3"
fuseki_port="$4"

# Backup the uploads directory.
#
# Note that the destination "uploads" directory has files added to it with each
# invocation; there are not separate dated sub-directories per backup as there
# are with the data directory (see below).
mkdir -p "$backup_dir"/uploads/
sudo rsync -a "$ldh_dir"/uploads/ "$backup_dir"/uploads/

# Backup the triplestore
curl "http://$host:$fuseki_port"/ds | gzip > "$backup_dir"/ldh-triples.trig.gz
