#!/bin/sh

if ! command -v brew --version &> /dev/null
then
    echo "installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "brew installed skipping"
fi

arch -arm64 brew bundle --file ./Brewfile

cp -p ./alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
cp -p ./neovim/init.vim ~/.config/nvim/init.vim
cp -p ./zsh/zshrc ~/.zshrc
cp -p ./tmux/tmux.conf ~/.tmux.conf
echo "copying complete"

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "installed nvim/plug"

