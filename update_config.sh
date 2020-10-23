#!/bin/sh
files=(".zshrc" ".oh-my-zsh/custom")

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

BASEDIR=$(dirname $0)

echo
for file in ${files[@]}; do

    if [ "$1" = "-r" ]; then
        from=$BASEDIR/$file
        to=~/$file
    else
        from=~/$file
        to=$BASEDIR/$file
    fi

    if [ -f "$to" ] || [ -d "$to" ]; then
        echo ${red}Removing $to
        sudo rm -r "$to"
    fi

    if [ -d "$from" ] && [ ! -d "$to" ]; then
        sudo mkdir -p $to
    fi

    echo ${green}Copying "$from" to "$to"
    if [ -d $to ]; then
        newTo=$(dirname "$to")
        sudo cp -r "${from}" "$newTo"

        echo Removing all .git folders
        sudo rm -rf $(find $to -type d -name .git)

    else
        sudo cp -r "$from" "$to"
    fi

    sudo chown -R eugen .

    echo
done

echo ${reset}Done...
