#!/bin/sh

if [ $# -eq 2 ]; then
    if [ ! $1 = "-u" ]; then
        cat ~/.ssh/id_rsa.pub | ssh $2 "cat >> ~/.ssh/authorized_keys"
    else
        echo "$1" is not supported as argument
        exit 1
    fi
elif [ $# -eq 1 ]; then
    cat ~/.ssh/id_rsa.pub | ssh $1 "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"
else
    echo Wrong number of arguments
    exit 2
fi

exit 0
