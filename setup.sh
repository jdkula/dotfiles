#!/bin/bash

BACKUP_DIR="~/.setup-backup/";

function install_prereqs() {
  echo "==== Installing prereqs, you may be prompted for your password: "
  sudo apt install zsh wget curl python3 python3-pip vim git zip unzip -y
}


function backup() {
  echo "==== Backing up..."
  mkdir -p "$BACKUP_DIR"
  mv -v .vimrc .vim .tmux.conf .zshrc .oh-my-zsh .p10k.zsh "$BACKUP_DIR"
}

function run_restore() {
  echo "==== Restoring..."
  mkdir -p "$BACKUP_DIR/restore_backup";
  mv -v .vimrc .vim .tmux.conf .zshrc .oh-my-zsh .p10k.zsh "$BACKUP_DIR/restore_backup"
  cd "$BACKUP_DIR"
  mv -v .vimrc .vim .tmux.conf .zshrc .oh-my-zsh .p10k.zsh ~
  cd -
}

function restore() {
  ls "$BACKUP_DIR" > /dev/null
  if [ $? -eq 0 ]; then
    run_restore
  else
    echo "==== Nothing to restore..."
  fi
}

function install() {
  echo "==== Cloning dotfiles..."
  git clone --depth=1 https://github.com/jdkula/dotfiles.git dotfiles
  rm -rf dotfiles/.git

  echo "==== Copying dotfiles into place"
  cp -rv dotfiles/.* .
  rm -rf dotfiles

  echo "==== Installing Vundle"
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim -E +PluginInstall +qall

  echo "==== Installing SSH keys"
  mkdir .ssh
  curl https://github.com/jdkula.keys > ~/.ssh/authorized_keys

  echo "==== Installing Oh My ZSH"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
}

PREREQS=
SKIP_BACKUP=

while getopts 'rsh' opt; do
  case "$opt" in
    r)
      PREREQS=TRUE
      ;;

    s)
      SKIP_BACKUP=TRUE
      ;;
   
    ?|h)
      echo "Usage: $(basename $0) [-a] [-b] [-c arg]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

set +x
START_DIR=$(pwd);

echo "==== Moving to home directory"
cd ~;

case "$1" in
  install)
    if [ "$PREREQS" = "TRUE" ]; then
      install_prereqs
    fi
    if [ "$SKIP_BACKUP" != "TRUE" ]; then
      backup
    fi
    install
    ;;
  restore)
    restore
    ;;
  *)
    echo "Usage: ./setup.sh (install | restore) [-r] [-s]"
    echo "-r and -s can be used with install. -r installs prereqs using apt. -s skips taking a backup."
    ;;
esac

echo "==== Moving back to start directory $START_DIR"
cd $START_DIR
