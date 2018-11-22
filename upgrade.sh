#!/bin/bash

BACKUP_LOC=$HOME/.config/myth-upgrade-backup

BG='\e[100m'
RESET='\e[0m'
FLIGHTGREEN='\e[92m'
FLIGHTRED='\e[91m'
FLIGHTCYAN='\e[96m'

function secho {
  echo -e "$BG$FLIGHTGREEN$@$RESET"
}

function vecho {
  echo -e "$FLIGHTGREEN$@$RESET"
}

function wecho {
  echo -e "$FLIGHTRED$@$RESET"
}

function recho {
  echo -e "$FLIGHTCYAN$@$RESET"
}

function clean {
  secho "==== Cleaning up for installation... ==="
  vecho "+ Removing .local"
  rm -rf $HOME/.local
  vecho "+ Removing ZSH"
  rm -rf $HOME/.oh-my-zsh
  vecho "+ Removing dein"
  rm -rf $HOME/.cache/dein
  vecho "+ Removing pv"
  rm -rf $HOME/pv
  vecho "+ Removing ycm"
  rm -rf .ycm_build
  rm -rf .regex_build
  vecho "+ Removing .gdbinit"
  rm -f $HOME/.gdbinit
  vecho "+ Removing .zshrc"
  rm -f $HOME/.zshrc
  vecho "+ Removing NeoVim configuration"
  rm -rf $HOME/.config/nvim
  vecho "+ Removing .tmux.conf"
  rm -f $HOME/.tmux.conf
  vecho "+ Removing clang archive"
  rm -rf "$HOME/clang.tar.xz"
}

function backup {
  secho "==== Backing up relevant files... ===="
  vecho "+ Creating Backup Location"
  mkdir -p $BACKUP_LOC || exit
  vecho "+ Backup Location: $BACKUP_LOC"
  vecho "+ Backing up .local"
  mkdir $BACKUP_LOC/.local
  rsync --info=progress2 --remove-source-files -a --include "*" "$HOME/.local/." "$BACKUP_LOC/.local/." 2> /dev/null
  vecho "+ Setting up PATH for local installation"
  PATH=$HOME/.local/bin:$PATH
  vecho "+ Backing up .gdbinit"
  mv $HOME/.gdbinit $BACKUP_LOC 2> /dev/null
  vecho "+ Backing up .zshrc"
  mv $HOME/.zshrc $BACKUP_LOC 2> /dev/null
  vecho "+ Backing up .oh-my-zsh"
  mv $HOME/.oh-my-zsh $BACKUP_LOC 2> /dev/null
  vecho "+ Backing up .bashrc"
  cp $HOME/.bashrc $BACKUP_LOC
  vecho "+ Backing up pv"
  mv -r $HOME/pv $BACKUP_LOC 2> /dev/null
  vecho "+ Backing up previous NeoVim configuration..."
  mkdir -p $BACKUP_LOC/.config/nvim
  rsync --info=progress2 --remove-source-files -a --include "*" "$HOME/.config/nvim/." "$BACKUP_LOC/.local/nvim/." 2> /dev/null
  vecho "+ Backing up .tmux.conf"
  mv $HOME/.tmux.conf $BACKUP_LOC 2> /dev/null
}

function gdbdash {
  secho "==== Setting up GDB Dashboard ===="
  vecho "+ Installing GDB Dashboard"
  wget -q --show-progress https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit -O $HOME/.gdbinit
}

function zshplugins {
  secho "==== Installing ZSH Plugins ===="
  vecho "+ Downloading zsh-completions"
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions
  vecho "+ Downloading zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  vecho "+ Downloading zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  echo "autoload -U compinit && compinit" >> .zshrc
}

function ohmyzsh {
  secho "==== Installing Oh My ZSH ===="
  vecho "+ Installing Oh My ZSH"
  printf "\n\nexit\n\n" | sh -c "$(wget -q --show-progress https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
  vecho "+ Installing .zshrc"
  rm $HOME/.zshrc
  wget -q --show-progress "https://raw.githubusercontent.com/jdkula/dotfiles/master/.zshrc" -O $HOME/.zshrc
}

function setzsh {
  secho "==== Setting BASH -> ZSH redirection ===="
  vecho "+ Setting up redirection"
  mv $HOME/.bashrc $HOME/.bashrc.bak
  echo "[[ \$- == *i* ]] && exec zsh && exit" > $HOME/.bashrc
  echo -e "\n" >> $HOME/.bashrc
  cat $HOME/.bashrc.bak >> $HOME/.bashrc
  rm $HOME/.bashrc.bak
}

function installpip {
  secho "==== Installing Python3 pip + NeoVim plugin ===="
  vecho "+ Downloading get-pip.py"
  wget -q --show-progress "https://bootstrap.pypa.io/get-pip.py" -O get-pip.py
  vecho "+ Installing pip"
  python2 get-pip.py --user
  python3 get-pip.py --user
  vecho "+ Installing NeoVim plugin"
  python2 -m pip install --user neovim
  python3 -m pip install --user neovim
  rm get-pip.py
}

function vundle {
  secho "==== Installing Vundle ===="
  vecho "+ Downloading Vundle"
  mkdir -p $HOME/.config/nvim/bundle
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.config/nvim/bundle/Vundle.vim

  secho "==== Installing vim Plugins ===="
  vecho "+ Installing (please wait, this may take a while!)"
  $HOME/.local/bin/nvim +PluginInstall +qall
  $HOME/.local/bin/nvim +UpdateRemotePlugins +qall
}

function pvinstall {
  secho "==== Installing pv ===="
  vecho "+ Downloading pv"
  git clone https://github.com/icetee/pv.git pv
  vecho "+ Building pv"
  cd pv
  ./configure > /dev/null
  make --silent 2> err
  vecho "+ Installing pv"
  cp pv $HOME/.local/bin
  cd ..
  rm -rf pv
}

function clanginstall {
  secho "==== Installing clang ===="
  vecho "+ Downloading clang"
  wget -q --show-progress "http://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz" -O clang.tar.xz
  vecho "+ Extracting clang"
  mkdir -p $HOME/.local
  $HOME/.local/bin/pv clang.tar.xz | tar -C "$HOME/.local" --strip-components=1 -xJf  -
  rm clang.tar.xz
}

function ycm {
  secho "==== Installing YouCompleteMe ===="
  YCM_LOC=$HOME/.config/nvim/bundle/YouCompleteMe

  vecho "+ Building YouCompleteMe Core"
  python $YCM_LOC/install.py --clang-completer --clang-tidy
}

function neovim {
  secho "==== Installing NeoVim ===="
  vecho "+ Downloading NeoVim"
  wget -q --show-progress "https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage" -O $HOME/.local/bin/nvim
  vecho "+ Installing NeoVim"
  chmod +x $HOME/.local/bin/nvim
  mkdir -p $HOME/.config/nvim
  wget -q --show-progress "https://raw.githubusercontent.com/jdkula/dotfiles/master/init.vim" -O $HOME/.config/nvim/init.vim
  echo -e '\n\n" ==== Added by upgrade.sh ====' >> ~/.config/nvim/init.vim
  echo -e "\nlet g:chromatica#libclang_path = '$HOME/.local/lib/libclang.so'" >> ~/.config/nvim/init.vim
  echo -e "\nlet g:chromatica#global_args = ['-isystem$HOME/.local/lib/clang/7.0.0/include']" >> ~/.config/nvim/init.vim
  echo "alias vim=nvim" >> .zshrc
}

function settmux {
  secho "==== Installing tmux Configuration ===="
  vecho "+ Downloading configuration"
  wget -q --show-progress "https://raw.githubusercontent.com/jdkula/dotfiles/master/.tmux.conf" -O $HOME/.tmux.conf
}

function bearinstall {
  secho "==== Installing Bear ===="
  vecho "+ Downloading Bear"
  git clone "https://github.com/rizsotto/Bear.git" Bear
  cd Bear
  vecho "+ Building Bear"
  rm CMakeLists.txt
  wget -q --show-progress "https://raw.githubusercontent.com/jdkula/dotfiles/master/upgradeFiles/CMakeLists.txt" -O $HOME/Bear/CMakeLists.txt
  cmake .
  make all
  vecho "+ Installing Bear"
  chmod +x bear/bear
  cp bear/bear $HOME/.local/bin
  mkdir -p $HOME/.local/lib/bear
  cp libear/libear.so $HOME/.local/lib/bear
  cd ..
  rm -rf Bear
}

function neovimhelp {
  echo "Vim has been upgraded to NeoVim. Simply type 'vim' (or 'nvim') to use it."
  echo "Please inspect ~/.config/nvim/init.vim to learn about new commands."
  echo "In order to set YCM (the vim IDE plugin) up, please run the following command:"
  vecho "make clean; bear make"
  echo "in the directory you're using for code editing. This generates a database"
  echo "Vim uses to provide code completion, etc."
}

function tmuxhelp {
  echo "Tmux has been configured. Please inspect ~/.tmux.conf to learn more."
}

function zshhelp {
  echo "ZSH has been set up, and set as your default shell. To go back to bash,"
  echo "delete the first line from .bashrc."
}

function restore {
  secho "$FLIGHTCYAN==== Restoring from $BACKUP_LOC ===="
  recho "+ Safeguarding current backup"
  RESTORE_LOC="$HOME/.config/myth-upgrade-restore"
  cd $HOME/.config
  mv myth-upgrade-backup myth-upgrade-restore
  cd $HOME
  if [[ "$BACKUP" = true ]]; then
    backup
  fi
  clean
  recho "+ Restoring..."
  rsync --info=progress2 -a --remove-source-files --include "*" "$RESTORE_LOC/." "$HOME/."
  rm -rf $RESTORE_LOC
  recho "+ Done!"
}

function main {
  if [[ "$BACKUP" = true ]]; then
    backup
  else
    mkdir -p $BACKUP_LOC
  fi
  clean
  mkdir -p $HOME/.local/bin 2> /dev/null
  settmux
  setzsh
  ohmyzsh
  zshplugins
  gdbdash
  installpip
  neovim
  pvinstall
  clanginstall
  bearinstall
  vundle
  ycm

  echo ""

  neovimhelp
  tmuxhelp
  zshhelp
}

OVERWRITE_BACKUP=false
RESTORE=false
BACKUP=true
UNINSTALL=false

while getopts ":frsu" opt; do
  case ${opt} in
    f )
      OVERWRITE_BACKUP=true
      ;;
    r )
      RESTORE=true
      ;;
    s )
      BACKUP=false
      ;;
    u )
      UNINSTALL=true
      ;;
    \? )
      echo "Usage: ./upgrade.sh [-f] [-r] [-s] [-u]";
      echo "-f : Force upgrade, even if it would overwrite a backup.";
      echo "-r : Backup current state, then restore.";
      echo "-u : Delete all files and folders used by this application WITHOUT backing up, then exit."
      echo "-s : Skip backup";
      exit -1;
      ;;
  esac
done

if [[ "$UNINSTALL" = true ]]; then
  clean
  exit 0
fi

if [[ "$RESTORE" = true ]]; then
    restore
    exit 0
fi

if [[ "$OVERWRITE_BACKUP" = true ]]; then
    rm -rf $BACKUP_LOC
fi

if [[ -e $BACKUP_LOC ]]; then
    wecho "The backup location ($BACKUP_LOC) already exists."
    echo "Please remove it before running this script, or run it with the -f option."
else
    main
fi
