#!/bin/sh

### "bash strict mode" quit on any non-zero exit status early  
## see http://redsymbol.net/articles/unofficial-bash-strict-mode/ 
set -euo pipefail
trap "echo 'error: Script failed: see failed command above'" ERR
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

### Color output setup ###
END="\e[0m"
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"

## Variables 
if [[ ! -d "$HOME/Downloads" ]]; then
    mkdir $HOME/Downloads
fi


info()
{
if [[ $# -ne 1 ]]; then
  echo "usage: info message"
  exit -1
fi
 echo -e "${GREEN} INFO: ... $1 ... ${END}\n"
}

warning()
{
    if [[ $# -ne 1 ]]; then
        echo "usage: warning <message>"
        exit -1
    fi
 echo -e "${YELLOW} WARNING: ... $1 ... ${END}\n"
}

## Install dev essential tools 
pushd "$HOME/Downloads"
sudo apt-get update 
## install sublime-text3 
wget -t 2 https://download.sublimetext.com/sublime-text_build-3114_amd64.deb
info "... install build-essentials...."
sudo apt-get install build-essential
## install checkinstall 
sudo apt-get install checkinstall
info "... install cmake ..."
wget -t 2 https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz -O cmake.tar.gz 
tar -xzf cmake.tar.gz
pushd cmake-3.5.2/
if [[ -z $(which cmake) ]]; then
    # no prior cmake found 
    ./bootstrap 
    make 
    make install 
else
    cmake .
    make 
    make install 
fi
## back to ~/Downloads
popd 
# finish by installing some additional command line tools
sudo apt-get install -y -q curl rsync tmux zip unzip unrar htop parallel
sudo apt-get install git 
git config --global user.name "Colin Lin"
git config --global user.email "colin.brat@gmail.com"
git config --global color.ui.auto 
info ".... install python tools ..."
sudo apt-get install python3
sudo apt-get install python-setuptools 
sudo apt-get install python-pip 
sudo apt-get install python3-pip 
sudo apt-get install g++

info ".... install node.js and npm ..."
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install nodejs 


info ".... install vim and config...."
sudo apt-get install vim
### pull vimrc 
scp hl41@178.62.176.117:~/backup/vimrc.backup ~/.vimrc 
## set up vundle 
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
## install all plugins 
vim +PluginInstall +qall
## install ack 
sudo apt-get install ack-grep
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

## install bashmark

git clone git://github.com/huyng/bashmarks.git
pushd bashmarks
make install 
## copy bashrc file 
scp hl41@178.62.176.117:~/backup/bashrc.backup ~/.bashrc

popd 

# back to Downloads
# Downlaod powershell 
ps_link_for_14=https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.9/powershell_6.0.0-alpha.9-1ubuntu1.14.04.1_amd64.deb
ps_link_for_16=https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.9/powershell_6.0.0-alpha.9-1ubuntu1.16.04.1_amd64.deb
info ".... Downloading Powershell ....."
ubuntu_ver=$(lsb_release -r)
ubuntu_ver=${ubuntu_ver##Release:}
ubuntu_ver=$(echo "${ubuntu_ver}" | xargs)
if [[ ${ubuntu_ver:0:2} = '14' ]]; then
    wget ${ps_link_for_14} -O $HOME/Downloads/powershell_alpha.deb 
    sudo apt-get install libunwind8 libicu52
    sudo dpkg -i powershell_alpha.deb
elif [[ ${ubuntu_ver:0:2} = '16' ]]; then
    wget ${ps_link_for_16} -O $HOME/Downloads/powershell_alpha.deb
        sudo apt-get install libunwind8 libicu55
        sudo dpkg -i powershell_alpha.deb
else
    warning "Did not find matching Ubuntu version when downloading Powershell"

fi
