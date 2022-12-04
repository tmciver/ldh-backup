#!/usr/bin/env bash

print_usage()
{
    printf "Restores a previous backup of LinkedDataHub data.\n"
    printf "\n"
    printf "Usage:  %s options\n" "$0"
    printf "\n"
    printf "Options:\n"
    printf "  -h, --host                           LDH hostname (optional; default: localhost)\n"
    printf "  -u, --user-port                      Port for Fuseki user data (optional; default: 3031)\n"
    printf "  -a, --admin-port                     Port for Fuseki admin data (optional; default: 3030)\n"
    printf "  -d, --data-source                    The name of the Fuseki data source (optional; default: ds)\n"
    printf "  -l, --ldh-dir                        LDH directory\n"
    printf "  -b, --backup-dir                     Directory in which to store backup data\n"
    printf "  -t, --timestamp                      The timestamp of the backup to restore. Has the form YYYYmmDDHHMM,\n"
    printf "                                       e.g., 202212041149 (it's the format you get from the output of 'date +\"%%Y%%m%%d%%H%%M\"').\n"
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
        -t|--timestamp)
        timestamp="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown arguments
        shift # past argument
        ;;
    esac
done

if [ -z "$ldh_dir" ] ; then
    printf "ldh_dir"
    print_usage
    exit 1
fi

if [ -z "$backup_dir" ] ; then
    printf "backup_dir"
    print_usage
    exit 1
fi

if [ -z "$timestamp" ] ; then
    printf "timestamp"
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

# Restore the uploads directory.
sudo rsync -a "$backup_dir"/uploads/ "$ldh_dir"/uploads/

# Restore the user triplestore
gunzip --stdout "$backup_dir/ldh-user-triples-$timestamp.trig.gz" | curl -X PUT -H "Content-Type: application/trig" --data-binary @- "http://$host:$user_port/$data_source"

# Restore the admin triplestore
gunzip --stdout "$backup_dir/ldh-admin-triples-$timestamp.trig.gz" | curl -f -X PUT -H "Content-Type: application/trig" --data-binary @- "http://$host:$admin_port/$data_source"
