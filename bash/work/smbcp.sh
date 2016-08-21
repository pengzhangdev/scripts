#! /bin/bash
#
# smbcp.sh ---
#
# Filename: smbcp.sh
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Sat Aug 20 20:11:16 2016 (+0800)
#

# Change Log:
#
#

# smbclient //werther-ap/xiaomi-usb0/ ""
# smbtree smb://werther-ap/xiaomi-usb0/log

function usage()
{
    ext=$1
    shift
    echo >&2 "Usage: `basename $0` [<options>] [<src>] [<target>]
Function: copy files/directories from/to smb server
Options         description
   -r           the src contains directories
   -u           username to login smb server
   -p           password to login smb server

Description:
U can just copy file without passing username or password. It will sending guest to try, then ask for username and password.
"
    echo >&2 "$@"
    exit $ext
}

if [ $# -eq 0 ]; then
    usage 2 "Please enter the commands!"
fi

dirmode=0
username=""
password=""
while getopts ru:p: c; do
    case $c in
        r) # Recursively copy entire directories
            dirmode=1
            ;;
        u)
            username=$OPTARG
            ;;
        p)
            password=$OPTARG
            ;;
        '?')
            Usage 2 "Invalid options - abort."
            ;;
    esac
done

shift `expr $OPTIND - 1`
# the rest arguments is src and dest
# echo $@; the last of $@ is dest and others are src
# Get the dest, if it starts with smb:// then the command should be smbclient to upload
# If the dest is local path , then the command should be smbget to download
# If failed to upload/download with guest, ask for username and password
source=""
target=""
flist="$@"
size=${#fliest[@]}
source_len=$(($size - 1))
target=${flist[$source_len]}
for((i=0; i<$source_len; i++))
do
    source="$source ${flist[i]}"
done

echo "source: $source; target: $target"
if [[ $target == smb://* ]]; then
    # upload mode
    echo "upload mode"
    exit 0
fi

if [ -d $target -a source_len -gt 0 ]; then
    smbget -a 
