#!/usr/bin/env bash

echo "==> Setting global variables"
ROOT_UID=0
FLAGS_PACMAN="--noconfirm --needed"
REPO="$HOME/repo/arch"
CONF="$REPO/config"

# check if executed as a user
echo "==> Checking if not root"
if [[ "$UID" == "$ROOT_UID" ]]; then
  whiptail --title "Arch config" --msgbox \
  "Please run this script as a user" 20 70
  exit 126
fi

# create directories
create_directories()
{
  echo "==> Creating directories"
  mkdir -p $HOME/repo
  mkdir -p $HOME/tmp
  mkdir -p $HOME/mnt
  mkdir -p $HOME/documents
  mkdir -p $HOME/music
  mkdir -p $HOME/movies
  mkdir -p $HOME/downloads
  mkdir -p $HOME/pictures/screenshots
}

clone_repositories()
{
  echo "==> Cloning repositories"
  # git clone git@gitlab.com:qeni/documents.git $HOME/repo/
}

# pacman
config_pacman()
{
  sudo vi/etc/pacman.conf
  echo "==> Setting pacman"
  sudo sh -c "echo '[archlinuxfr]' >> /etc/pacman.conf"
  sudo sh -c "echo 'SigLevel = Never' >> /etc/pacman.conf"
  sudo sh -c "echo \
  'Server = http://repo.archlinux.fr/x86_64' >> /etc/pacman.conf"
  sudo pacman -Syu $FLAGS_PACMAN
}

install_packages()
{
  # installing packages
  echo "==> Installing packages"
  sudo pacman -S \
  alsa-utils powerline-fonts links \
  vim cmake curl ctags lua ttf-dejavu terminus-font \
  python python2 gcc cmake zsh acpi yaourt nethack autopep8 \
  git htop newsboat youtube-dl rtorrent irssi \
  mc nmap retext python-pylint \
  ncmpcpp mpd mpc \
  python-jedi python2-jedi \
  p7zip unrar unzip zip openssh  $FLAGS_PACMAN

  echo "==> Installing packages from AUR"
  yaourt -S xcalib $FLAGS_PACMAN
}

install_gui()
{
  sudo pacman -S \
  xorg-server xorg-xrandr xorg-xrdb mesa mesa-libgl \
  xorg-xinit xf86-video-intel lib32-mesa-libgl xorg-xbacklight \
  dmenu feh \
  i3lock i3status \
  $FLAGS_PACMAN 
  # i3-wm \
}

install_gui_applications()
{
  sudo pacman -S \
  leafpad vlc scrot gimp gmtp redshift firefox lxrandr \
  zathura zathura-pdf-poppler xterm \
  $FLAGS_PACMAN 

  yaourt -S ttf-font-awesome i3-gaps \
  $FLAGS_PACMAN
  # pycharm-community-edition 
}

install_tex()
{
  sudo pacman -S texmaker texlive-core \
  texlive-science texlive-pictures texlive-fontsextra texlive-latexextra \
  $FLAGS_PACMAN 
}

copy_dotfiles()
{
  echo "==> Copying dotfiles"
  cp -R -n $CONF/dotfiles/. $HOME
}

clone_dotfiles()
{
  cd $HOME
  git init
  git remote add origin git@github.com:dudekmichal/dotfiles.git
  git checkout -b master
  git pull origin master
}

config_other()
{
  echo "==> Setting other packages"
  chsh -s /bin/zsh $USER
  xrdb -merge $HOME/.Xresources
  sudo cp $CONF/etc/locale.gen /etc/locale.gen
  sudo cp $CONF/etc/locale.gen /etc/locale.gen
  sudo cp $CONF/etc/locale.conf /etc/locale.conf
  sudo cp $CONF/etc/vconsole.conf /etc/vconsole.conf
  sudo locale-gen

  sudo mkdir -p /var/games/nethack
  sudo cp $CONF/nethack/record /var/games/nethack/record
}

copy_scripts()
{
  echo "==> Copying scripts"
  sudo cp $REPO/scripts/m /usr/local/bin/
  sudo cp $REPO/scripts/um /usr/local/bin/
  sudo cp $REPO/scripts/live-usb /usr/local/bin/
  sudo cp $REPO/scripts/take-screenshot /usr/local/bin/
  sudo cp $REPO/scripts/take-screenshot-s /usr/local/bin/
  sudo chmod +x /usr/local/bin/m
  sudo chmod +x /usr/local/bin/um
  sudo chmod +x /usr/local/bin/live-usb
  sudo chmod +x /usr/local/bin/take-screenshot
  sudo chmod +x /usr/local/bin/take-screenshot-s
}

disable_beep()
{
  echo "==> Disabling beep"
  sudo rmmod pcspkr
  sudo sh -c "echo 'blacklist pcspkr' >> /etc/modprobe.d/blacklist"
}

set_polish()
{
  echo "==> Setting polish letters"
  sudo cp $CONF/etc/vconsole.conf /etc/vconsole.conf
  sudo cp $CONF/etc/locale.gen /etc/locale.gen
  sudo locale-gen
  # sudo export LANG=pl_PL.UTF-8
  sudo cp $CONF/etc/locale.conf /etc/locale.conf
  sudo setfont /usr/share/kbd/consolefonts/Lat2-Terminus16.psfu.gz
}

main()
{
  create_directories
  clone_repositories
  config_pacman
  install_packages
  install_gui
  install_gui_applications
  install_tex
  clone_dotfiles
  config_other
  copy_scripts
  disable_beep
  set_polish
}

main
