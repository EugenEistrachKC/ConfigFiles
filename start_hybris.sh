#!/bin/sh

basedir=~/Projects/konecranes/hybris/hybris/bin
platformdir=$basedir/platform

cd $platformdir

. ./setantenv.sh
ls
./hybrisserver.sh debug

echo
exit 0
