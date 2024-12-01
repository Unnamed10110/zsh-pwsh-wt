#!/bin/zsh

cd "$HOME"
sudo apt update
sudo apt upgrade
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


sudo git clone https://github.com/Unnamed10110/zsh-pwsh-wt.git

 cp -r zsh-pwsh-wt/kaliPersonalConfig/debian/Home/.  .

xargs -a installed_packages.txt -I {} sh -c 'echo "Installing {}..."; sudo apt-get install -y {}'


git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting                                                                                                                                       
git clone https://github.com/z-shell/H-S-MW.git \ ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/H-S-MW
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text



git clone https://github.com/bamos/zsh-history-analysis.git
sudo apt install r-base
sudo Rscript -e "install.packages('ggplot2')"
sudo Rscript -e "install.packages('reshape')"
