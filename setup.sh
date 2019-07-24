#!/bin/bash

cd ~

sudo apt upgrade
sudo apt install build-essential cmake zsh wget curl python3 python3-pip python3-dev vim-nox git zip unzip -y

wget https://github.com/jdkula/dotfiles/archive/master.zip
unzip master.zip

cp dotfiles-master/.* .
rm -rf dotfiles-master
rm master.zip

mv .zshrc .zshrc.bak

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

rm .zshrc
mv .zshrc.bak .zshrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

cd ~/.vim/bundle/YouCompleteMe
python3 install.py

cd -

mkdir .ssh
curl https://github.com/jdkula.keys > ~/.ssh/authorized_keys
