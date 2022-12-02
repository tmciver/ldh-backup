#!/usr/bin/env bash

print_usage()
{
    printf "Creates a backup of LinkedDataHub data.\n"
    printf "\n"
    printf "Usage:  %s options\n" "$0"
    printf "\n"
    printf "Options:\n"
    printf "  -h, --host                           LDH hostname (optional; default: localhost)\n"
    printf "  -p, --port                           Port for Fuseki (optional; default: 3030)\n"
    printf "  -d, --ldh-dir                        LDH directory\n"
    printf "  -b, --backup-dir                     Directory in which to store backup data\n"
}

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -h|--host)
        host="$2"
        shift # past argument
        shift # past value
        ;;
        -p|--port)
        port="$2"
        shift # past argument
        shift # past value
        ;;
        -d|--ldh-dir)
        ldh_dir="$2"
        shift # past argument
        shift # past value
        ;;
        -b|--backup-dir)
        backup_dir="$2"
        shift # past argument
        shift # past value
        ;;
    esac
done

if [ -z "$host" ] ; then
    host=localhost
fi

if [ -z "$port" ] ; then
    port=3030
fi

if [ -z "$ldh_dir" ] ; then
    print_usage
    exit 1
fi

if [ -z "$backup_dir" ] ; then
    print_usage
    exit 1
fi

# Backup the uploads directory.
#
# Note that the destination "uploads" directory has files added to it with each
# invocation; there are not separate dated sub-directories per backup as there
# are with the data directory (see below).
mkdir -p "$backup_dir"/uploads/
sudo rsync -a "$ldh_dir"/uploads/ "$backup_dir"/uploads/

# Backup the triplestore
curl "http://$host:$port"/ds | gzip > "$backup_dir"/ldh-triples-$(date +"%Y%m%d%H%M").trig.gz
