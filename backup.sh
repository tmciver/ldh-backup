#!/usr/bin/env bash

print_usage()
{
    printf "Creates a backup of LinkedDataHub data.\n"
    printf "\n"
    printf "Usage:  %s options\n" "$0"
    printf "\n"
    printf "Options:\n"
    printf "  -h, --host                           LDH hostname (optional; default: localhost)\n"
    printf "  -u, --user-port                      Port for Fuseki user data (optional; default: 3031)\n"
    printf "  -a, --admin-port                     Port for Fuseki admin data (optional; default: 3030)\n"
    printf "  -l, --ldh-dir                        LDH directory\n"
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
        -u|--user-port)
        user_port="$2"
        shift # past argument
        shift # past value
        ;;
        -a|--admin-port)
        admin_port="$2"
        shift # past argument
        shift # past value
        ;;
        -l|--ldh-dir)
        ldh_dir="$2"
        shift # past argument
        shift # past value
        ;;
        -b|--backup-dir)
        backup_dir="$2"
        shift # past argument
        shift # past value
        ;;
        -d|--data-source)
        data_source="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown arguments
        shift # past argument
        ;;
    esac
done

if [ -z "$ldh_dir" ] ; then
    print_usage
    exit 1
fi

if [ -z "$backup_dir" ] ; then
    print_usage
    exit 1
fi

if [ -z "$host" ] ; then
    host=localhost
fi

if [ -z "$user_port" ] ; then
    user_port=3031
fi

if [ -z "$admin_port" ] ; then
    admin_port=3030
fi

if [ -z "$data_source" ] ; then
    data_source="ds"
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

# Backup the user triplestore
timestamp=$(date +"%Y%m%d%H%M")
curl -f "http://$host:$user_port/$data_source" | gzip > "$backup_dir/ldh-user-triples-$timestamp.trig.gz"

# Backup the admin triplestore
curl -f "http://$host:$admin_port/$data_source" | gzip > "$backup_dir/ldh-admin-triples-$timestamp.trig.gz"
