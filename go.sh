if [ -d ~/.zprezto ]
then
  echo "\033[0;33mYou already have prezto installed.\033[0m Upgrading..."
  cd ~/.zprezto
  /usr/bin/env git add .
  /usr/bin/env git commit -a -m["Commit changes before upgrade"]
  /usr/bin/env git pull
  exit
fi

zsh

echo "\033[0;34mCloning prezto...\033[0m"
hash git >/dev/null && /usr/bin/env git clone --recursive https://github.com/loranger/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" || {
  echo "\033[0;31mFailed : Git is not installed\033[0m"
  os=`uname`
  if [[ "$os" == 'Linux' ]]; then
    url='http://git-scm.com/download/linux'
  elif [[ "$os" == 'Darwin' ]]; then
    url='http://brew.sh/'
  else
    url='http://git-scm.com/'
  fi

  echo " ➥ You should really take a look at $url"
  exit
}

if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]
then
  echo "\033[0;33mFound ~/.zshrc.\033[0m \033[0;32mBacking up to ~/.zshrc.old\033[0m";
  mv ~/.zshrc ~/.zshrc.old;
fi

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

echo "\033[0;34mSet zsh as your default shell\033[0m"
chsh -s `which zsh`

echo "\n\n \033[0;32mPrezto is ready\033[0m"
/usr/bin/env zsh
source ~/.zshrc