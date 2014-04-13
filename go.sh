#!/bin/sh
# Usage: go.sh [--ssh] <githubuser>
#  --ssh : clone repository with ssh scheme instead of https
#
# To set a parameter, you must add "-s" to sh, like:
# wget <url> -O - | sh -s --ssh <githubuser>
#

# Help oneliner:
[ "$1" = "--help" ] && { sed -n -e '/^# Usage:/,/^$/ s/^# \?//p' < $0; exit; }

clear
echo ""

githubuser=loranger
cloneurl=https://github.com/
cloneurlend=.git
while [ $# -gt 0 ]
do
	case "$1" in
		--ssh) cloneurl=git@github.com:
			cloneurlend=
			;;
		*)
			githubuser=$1;
			;;
	esac
	shift
done
cloneurl=$cloneurl$githubuser/prezto$cloneurlend

hash zsh 2>/dev/null || {
  echo "\033[0;31mFailed : ZSH is missing\033[0m"
  echo " ➥ Prezto does not work without ZSH. Install it first."
  echo ""
  exit
}

if [ -d ~/.zprezto ]
then
  echo "\033[0;33mYou already have prezto installed.\033[0m Upgrading..."
  cd ~/.zprezto
  # git pull && git submodule update --init --recursive
  /usr/bin/env git add .
  /usr/bin/env git commit --all --message "Commit changes before upgrade" --quiet
  /usr/bin/env git pull --recurse-submodules
  /usr/bin/env git submodule update
  exit
fi

echo "\033[0;34mCloning prezto...\033[0m"
hash git >/dev/null && /usr/bin/env git clone --recursive $cloneurl "${ZDOTDIR:-$HOME}/.zprezto" >/dev/null 2>&1 || {
  echo "\033[0;31mFailed : Git is not installed\033[0m"
  os=`uname`
  if [ "$os" == 'Linux' ]; then
    url='http://git-scm.com/download/linux'
  elif [ "$os" == 'Darwin' ]; then
    url='http://brew.sh/'
  else
    url='http://git-scm.com/'
  fi

  echo " ➥ You should really take a look at $url"
  exit
}

for file in $HOME/.zprezto/runcoms/z*
do
  rcfile=`basename $file`
  if [ -f $HOME/.$rcfile ] || [ -h $HOME/.$rcfile ]
  then
    echo "\033[0;33mFound ~/.$rcfile file.\033[0m \033[0;32mMoved to ~/.$rcfile.old\033[0m";
    mv $HOME/.$rcfile $HOME/.$rcfile.old;
  fi
  ln -s $file $HOME/.$rcfile
done

echo "\033[0;32mPrezto is ready\033[0m"

echo "\033[0;34mNow set zsh as your default shell by typing :\033[0m"
echo "chsh -s $(which zsh)"
echo "\033[0;34mand start a new term.\033[0m"
