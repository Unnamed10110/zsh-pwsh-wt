sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo apt update && sudo apt update && sudo apt install -y fzf bat ripgrep zsh curl git neovim dos2unix curl wget git zsh nmap tree build-essential python3-pip jq 

dos2unix ~/.zshrc

source .zshrc

git clone https://github.com/Unnamed10110/zsh-pwsh-wt.git

cp -rf /home/unnamed10110/zsh-pwsh-wt/kaliPersonalConfig/automate_zsh.sh .

cp -rf zsh-pwsh-wt/kaliPersonalConfig/debian/Home/. .

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

git clone https://github.com/z-shell/H-S-MW.git

cp -rf H-S-MW .oh-my-zsh/custom/plugins/H-S-MW/

rm -rf H-S-MW

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

cp -rf zsh-pwsh-wt/kaliPersonalConfig/debian/Home/jonathan.zsh-theme .oh-my-zsh/themes/.

sudo apt update
sudo apt install gnupg

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get update
sudo apt-get install sublime-text

sudo apt update
sudo apt install libgl1

sudo ln -sf /home/YOUR_USERNAME/.zsh_history /root/.zsh_history

sudo compaudit | xargs chmod go-w
sudo chmod -R go-w $(compaudit)


# sudo, config to root

sudo -i zsh -c "sed -i 's/\r\$//' ~/.zshrc && find ~/.oh-my-zsh -type f -exec sed -i 's/\r\$//' {} + && source ~/.zshrc && sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" && cp ~/.zshrc /root/ && cp -rf ~/.oh-my-zsh /root/ && chown -R root:root /root/.zshrc /root/.oh-my-zsh && source ~/.zshrc && clear && sleep 4 && exit"
