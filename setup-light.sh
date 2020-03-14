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

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

mkdir .ssh
curl https://github.com/jdkula.keys > ~/.ssh/authorized_keys

mv .zshrc .zshrc.bak

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

rm .zshrc
mv .zshrc.bak .zshrc
