#!/bin/bash

sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /tmp/ init --apply --verbose plytro/dotfiles

##
# asdf
##
if [[ -d ~/.asdf ]]; then
  source ~/.asdf/asdf.sh
  asdf update
else
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  source ~/.asdf/asdf.sh
fi

# Install this one as asdf won't overwrite something installed already
asdf plugin add oc latest https://github.com/sqtran/asdf-oc.git

# This is lazy, it's why I force ^ oc to come from a url. 
# it assumes the plugins are all standard
for plugin in $(awk '{print $1}' ~/.tool-versions); do
  asdf plugin add "${plugin}"
done

asdf install

# configure pre-commit on clones
git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template

# install krew plugins
for plugin in $(awk '{print $1}' ~/.krew-installs); do
  kubectl krew install $plugin
done

mkdir -p ~/tmp
mkdir -p ~/bin

curl --silent --location --output-dir ~/bin --remote-name "https://github.com/so-fancy/diff-so-fancy/releases/download/v1.4.4/diff-so-fancy" 
chmod 755 ~/bin/diff-so-fancy

source ${HOME}/.bash_profile
