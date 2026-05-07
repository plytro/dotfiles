#!/bin/bash

sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /tmp/ init --apply --verbose plytro/dotfiles

# mise
curl https://mise.run | sh
eval "$(~/.local/bin/mise activate bash)"
mise install

# configure pre-commit on clones
git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template

# install krew plugins
for plugin in $(awk '{print $1}' ~/.krew-installs); do
  krew install $plugin
done

mkdir -p ~/tmp
mkdir -p ~/bin
mkdir -p ~/in

curl --silent --location --output-dir ~/bin --remote-name "https://github.com/so-fancy/diff-so-fancy/releases/download/v1.4.4/diff-so-fancy" 
chmod 755 ~/bin/diff-so-fancy

source ${HOME}/.bash_profile
