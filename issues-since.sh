#!/bin/sh

if [ ! $# -gt 0 ]; then
  echo "Usage: $0 <git-tag> [<git-branch>]"
  exit 1
fi

orange=$(tput setaf 3)
green=$(tput setaf 2)
reset=$(tput sgr0)

tag=$1
branch=${2:-release}

curDir=$(dirname $0)
dir=$curDir/tmp

if [ ! -d $dir ]; then
  sudo mkdir -p $dir
fi

cd $dir

repo_name=kc-hybris

echo "Cloning repository: $orange$repo_name$reset"
sudo git clone --quiet https://github.com/KC-Hybris/$repo_name >/dev/null
cd $repo_name
echo "Checking out $orange$branch$reset branch"
sudo git checkout --quiet $branch >/dev/null

# copies result to clipboard (pbcopy is mac only)
git log --pretty=format:"%s" --no-merges $1..HEAD | sed 's/.*SAPHYBRIS/SAPHYBRIS/;s/.*SAPECOM/SAPECOM/;s/[ |:].*//' | grep 'SAPHYBRIS\|SAPECOM' | sort -u | paste -d, -s - | pbcopy

cd ..
cd ..

sudo rm -r $dir

echo
echo ${green}Issues copied to clipboard!${reset}

exit 0
