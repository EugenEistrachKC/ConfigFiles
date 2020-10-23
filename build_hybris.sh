#!/bin/sh

basedir=~/Projects/konecranes/hybris/hybris/bin
platformdir=$basedir/platform

orange=$(tput setaf 3)
green=$(tput setaf 2)
reset=$(tput sgr0)

if [ $# -gt 0 ]; then
    folder=$1
    buildpath=$basedir/custom/global/$folder

    if [ $folder = "hybris" ]; then
        $buildpath=$platformdir
    fi

    cd $platformdir
    . ./setantenv.sh

    cd $buildpath

    if [ "$2" = "-c" ]; then
        echo "$orange$buildpath $reset>$green ant clean all$reset"
        ant clean all
    else
        echo "$orange$buildpath $reset>$green ant all$reset"
        ant all
    fi
else
    echo "Usage: $0 <build-target> [-c]"
    exit 1
fi

echo
exit 0
