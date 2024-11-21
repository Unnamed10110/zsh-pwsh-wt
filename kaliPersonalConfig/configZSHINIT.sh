#!/bin/zsh

cd "$HOME"

sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


sudo git clone https://github.com/Unnamed10110/zsh-pwsh-wt.git

 cp -r zsh-pwsh-wt/kaliPersonalConfig/debian/Home/.  .

 cat ~/zsh-pwsh-wt/kaliPersonalConfig/debian/installed_packages | sudo apt install


git clone https://github.com/bamos/zsh-history-analysis.git
sudo apt install r-base
sudo Rscript -e "install.packages('ggplot2')"
sudo Rscript -e "install.packages('reshape')"
