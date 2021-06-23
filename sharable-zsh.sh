#!/bin/bash

cd ~

#should have these packages installed: zsh git curl

mv ~/.zshrc ~/.zshrc.old-bak

git clone https://github.com/jdkula/dotfiles.git jonathan-dotfiles

cp jonathan-dotfiles/.zshrc ~
cp jonathan-dotfiles/.p10k.zsh ~

rm -rf jonathan-dotfiles

mv ~/.zshrc ~/.zshrc.bak

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

rm .zshrc
mv .zshrc.bak .zshrc

echo "run 'exec zsh' to start using the new config"
