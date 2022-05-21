#!/bin/bash

BACKUP_DIR="$HOME/.setup-backup";

function backup() {
  echo "==== Backing up..."
  ls "$BACKUP_DIR" > /dev/null
  if [ $? -eq 0 ]; then
    echo "=== Keeping old directory"
    BAK_BASE="bak-copy-$(date +%s)"
    BAK_BAK="$HOME/$BAK_BASE"
    mv -v "$BACKUP_DIR" "$BAK_BAK"
    mkdir -p "$BACKUP_DIR"
    mv -v "$BAK_BAK" "$BACKUP_DIR/$BAK_BASE"
  fi
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
  cp -rv dotfiles/.vimrc dotfiles/.tmux.conf dotfiles/.zshrc dotfiles/.p10k.zsh ./
  rm -rf dotfiles

  echo "==== Installing Vundle"
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim -E -c PluginInstall -c qall

  echo "==== Installing SSH keys"
  mkdir .ssh
  curl https://github.com/jdkula.keys > ~/.ssh/authorized_keys

  echo "==== Installing Oh My ZSH"
  mv .zshrc .zshrc-setup
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  mv .zshrc .zshrc.omz
  mv .zshrc-setup .zshrc
}

set +x
START_DIR=$(pwd);

echo "==== Moving to home directory"
cd ~;

case "$1" in
  install)
    case "$2" in
      -a)
        echo "==== Installing prereqs with apt, your password may be needed:"
        sudo apt install -y zsh wget curl python3 python3-pip vim git zip unzip
        ;;
      -b)
        echo "==== Installing prereqs with brew:"
        which brew > /dev/null
        if [ $? -ne 0 ]; then
          echo "=== Installing brew:"
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install wget curl python3 vim git zip unzip
        ;;
    esac
    backup
    install
    ;;
  restore)
    restore
    ;;
  *)
    echo "Usage: ./setup.sh (install | restore) [-a] [-b]"
    echo "-a and -b can be used with install. -a installs prereqs using apt. -b does the same with brew"
    ;;
esac

echo "==== Moving back to start directory $START_DIR"
cd $START_DIR
