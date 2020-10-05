#!/bin/sh

orange=$(tput setaf 3)
green=$(tput setaf 2)
reset=$(tput sgr0)

add_tag() {
    repo_name=$1
    branch=$2
    tag=$3

    echo "Cloning repository: $orange$repo_name$reset"
    sudo git clone --quiet https://github.com/KC-Hybris/$repo_name >/dev/null
    cd $repo_name
    echo "Checking out $orange$branch$reset branch"
    sudo git checkout --quiet $branch >/dev/null

    echo "Tagging $orange$branch$reset with $orange$tag$reset"
    sudo git tag $tag >/dev/null

    echo "Pushing $orange$tag$reset to remote"
    git push --quiet --tags >/dev/null

    cd ..

    echo ${green}Done...$reset
}

if [ $# -gt 0 ]; then
    tag=$1
    branch=${2:-release}

    curDir=$(dirname $0)
    dir=$curDir/tmp

    if [ ! -d $dir ]; then
        sudo mkdir -p $dir
    fi

    cd $dir

    add_tag kc-hybris $branch $tag
    echo
    add_tag kc-datahub $branch $tag

    cd ..

    sudo rm -r $dir
else
    echo "Usage: $0 <git-tag> [<git-branch>]"
    exit 1
fi

echo
exit 0
