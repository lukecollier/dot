#!/bin/sh

if ! command -v brew --version &> /dev/null
then
    echo "installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "brew installed skipping"
fi

brew install java
brew bundle --file ./Brewfile

/opt/homebrew/opt/fzf/install --all

sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk \
     /Library/Java/JavaVirtualMachines/openjdk.jdk

cs setup --yes

coursier bootstrap \
  --java-opt -XX:+UseG1GC \
  --java-opt -XX:+UseStringDeduplication  \
  --java-opt -Xss4m \
  --java-opt -Xms100m \
  org.scalameta:metals_2.12:0.11.2+177-fb896d65-SNAPSHOT -o metals -f

mkdir -p ~/.config/alacritty
mkdir -p ~/.config/nvim
cp ./alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp ./neovim/init.lua ~/.config/nvim/init.lua
cp ./zsh/zshrc ~/.zshrc
cp ./tmux/tmux.conf ~/.tmux.conf
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
