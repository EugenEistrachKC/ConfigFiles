#!/bin/sh

orange=$(tput setaf 3)
green=$(tput setaf 2)
reset=$(tput sgr0)

remove_tag() {
    repo_name=$1
    tag=$2

    echo "Cloning repository: $orange$repo_name$reset"
    sudo git clone --quiet https://github.com/KC-Hybris/$repo_name >/dev/null
    cd $repo_name

    echo "Removing $orange$tag$reset from remote..."
    git push --quiet origin :refs/tags/$tag

    cd ..

    echo ${green}Done...$reset
}

if [ $# -gt 0 ]; then
    tag=$1

    curDir=$(dirname $0)
    dir=$curDir/tmp

    if [ ! -d $dir ]; then
        sudo mkdir -p $dir
    fi

    cd $dir

    remove_tag kc-hybris $tag
    echo
    remove_tag kc-datahub $tag

    cd ..

    sudo rm -r $dir
else
    echo "Usage: $0 <git-tag>"
    exit 1
fi

echo
exit 0
