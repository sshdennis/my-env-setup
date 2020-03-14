#!/bin/bash

set -o nounset  # set -u: exit while trying to use an uninitialised variable
# set -o xtrace   # set -x: execution tracing debug messages
set -o errexit  # set -e: exit the script if an error happens

DEF_NODEJS_VERSION="v12.16.1"
LOCAL_PATH=`pwd`
ENV_PROFILE="bin/.env_profile"

echo "[INFO] Running setup script..."

read -p "Enter git name: " git_name
read -p "Enter git email: " git_email

if [ -z "$git_name" ]
then
    echo "[ERROR] You MUST configure git name setting!"
    exit 1
else
    echo "[INFO] git name is $git_name"
fi

if [ -z "$git_email" ]
then
    echo "[ERROR] You MUST configure git email setting!"
    exit 1
else
    echo "[INFO] git email is $git_email"
fi

echo "[INFO] Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install wget
brew install git

echo "[INFO] Install nvm"
cd ~/
git clone https://github.com/nvm-sh/nvm.git .nvm
cd ~/.nvm
. nvm.sh
command -v nvm
cd $LOCAL_PATH

echo "[INFO] Install nodejs"
nvm install $DEF_NODEJS_VERSION
nvm use $DEF_NODEJS_VERSION
nvm alias default $DEF_NODEJS_VERSION

echo "[INFO] Setup git"
git config --global user.name  $git_name
git config --global user.email $git_email

git config --global help.autocorrect 30

git config --global core.autocrlf  false
git config --global core.quotepath false

git config --global color.diff   auto
git config --global color.status auto
git config --global color.branch auto

git config --global alias.co    checkout
git config --global alias.ci    commit
git config --global alias.cm    commit --amend -C HEAD
git config --global alias.br    branch
git config --global alias.st    status
git config --global alias.sts   status -s
git config --global alias.re    remote
git config --global alias.di    diff
git config --global alias.l     log --oneline --graph
git config --global alias.lg    log --graph --pretty=format:'%Cred%h%Creset %ad |%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset [%Cgreen%an%Creset]' --abbrev-commit --date=short
git config --global alias.pl    pull
git config --global alias.plu   pull upstream master
git config --global alias.alias config --get-regexp ^alias\\.\

# bash_profile
cp $ENV_PROFILE ~/
echo ". $ENV_PROFILE" >> ~/.bash_profile

echo "..."
echo "..."
echo "[INFO] Running setup script done, please restart terminal."
