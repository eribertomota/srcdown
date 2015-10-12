#!/bin/bash

# C 2014-2015 Joao Eriberto Mota Filho <eriberto@debian.org>
# Last-Update: 2015-10-12

if [ ! "$1" ]; then echo "No data to process. Please, use a Debian maintainer name or an e-mail address."; exit 0; fi

LISTS=$(find /var/lib/apt/lists/ -maxdepth 1 | egrep debian\.'(net|org)' | grep 'Sources$' | sort)

[ ! "$LISTS" ] && { echo -e "No source lists found. Please, add a deb-src line to /etc/apt/sources.list\nand run apt-get update."; exit 0; }

PKGS=$(cat $LISTS | egrep '(Maintainer|Uploaders)' -C 5 | grep -i "$1" -C 5 | grep '^Package:' | cut -d" " -f2 | sort -n)

echo $PKGS | tr ' ' '\n' | sort -u | cat -n

echo -e "\nDownload all debian directories? (type yes to download)\n"

read OPT

if [ "$OPT" = "yes" ]
then
    echo -e "Downloading into $1_PKGS\n"
    sleep 1
    mkdir $1_PKGS || exit 1
    cd $1_PKGS && echo $PKGS; apt-get source -d $PKGS
else
    echo "Bye!"
    exit 0
fi

FILES=$(ls *debian.tar*)

for i in $FILES
do
    NAME=$(echo $i|cut -d"_" -f1)
    tar -xvf $i
    mv debian $NAME
done

echo -e "\nRemoving trash\n"
sleep 1
find -maxdepth 1 -type f -exec rm -f {} \;

echo -e "\nCreating a compact changelog\n"
sleep 1
cd ..
find $1_PKGS -mindepth 2 -type f -name '*changelog*' -exec cat {} \; > $1.changelogs
