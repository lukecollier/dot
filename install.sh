#!/bin/sh

if ! command -v brew --version &> /dev/null
then
    echo "installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "brew installed skipping"
fi

if [[ $(uname -m) == 'arm64' ]]; then
  arch -arm64 brew bundle --file ./Brewfile
else
  brew bundle --file ./Brewfile
fi  

coursier bootstrap \
  --java-opt -XX:+UseG1GC \
  --java-opt -XX:+UseStringDeduplication  \
  --java-opt -Xss4m \
  --java-opt -Xms100m \
  org.scalameta:metals_2.12:0.11.2+177-fb896d65-SNAPSHOT -o metals -f

cp -p ./alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
cp -p ./neovim/init.vim ~/.config/nvim/init.vim
cp -p ./zsh/zshrc ~/.zshrc
cp -p ./tmux/tmux.conf ~/.tmux.conf
echo "copying complete"

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "installed nvim/plug"

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.a add
echo "setting up git alias"
