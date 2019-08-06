#!/bin/bash

cd ~

sudo apt upgrade
sudo apt install zsh wget curl python3 python3-pip vim git zip unzip -y

wget https://github.com/jdkula/dotfiles/archive/master.zip
unzip master.zip

cp dotfiles-master/.* .
rm -rf dotfiles-master
rm master.zip
rm .vimrc
mv .vimrc-light .vimrc

mv .zshrc .zshrc.bak

rm .zshrc
mv .zshrc.bak .zshrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

mkdir .ssh
curl https://github.com/jdkula.keys > ~/.ssh/authorized_keys

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
