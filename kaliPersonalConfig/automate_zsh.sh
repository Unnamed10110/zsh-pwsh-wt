#!/bin/bash

# Ask for sudo password once at the beginning
sudo -v

# Keep sudo alive during script execution
( while true; do sudo -n true; sleep 60; done ) &

# Install Oh My Zsh
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Update & install packages
sudo apt update && sudo apt install -y \
    fzf bat ripgrep zsh curl git neovim dos2unix wget \
    nmap tree build-essential python3-pip jq gnupg libgl1

# Clean up CRLF line endings in .zshrc
dos2unix ~/.zshrc

# Reload zsh config
source ~/.zshrc

# Clone your config repo
git clone https://github.com/Unnamed10110/zsh-pwsh-wt.git

# Copy configs
cp -rf zsh-pwsh-wt/kaliPersonalConfig/automate_zsh.sh .
cp -rf zsh-pwsh-wt/kaliPersonalConfig/debian/Home/. .

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install custom plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

git clone https://github.com/z-shell/H-S-MW.git
cp -rf H-S-MW "$ZSH_CUSTOM/plugins/H-S-MW/"
rm -rf H-S-MW

git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
git clone https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete"

# Copy theme
cp -rf zsh-pwsh-wt/kaliPersonalConfig/debian/Home/jonathan.zsh-theme "$HOME/.oh-my-zsh/themes/"

# Setup Sublime Text repo and install
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update && sudo apt install -y sublime-text

# Link root's zsh history to user's history
sudo ln -sf "/home/$USER/.zsh_history" /root/.zsh_history

# Fix insecure permissions (if applicable)
chmod 755 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_brew 2>/dev/null
chmod -R go-w /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_brew 2>/dev/null

# End sudo keep-alive loop
kill %%
