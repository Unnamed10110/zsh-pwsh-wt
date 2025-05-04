sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo apt update && sudo apt install dos2unix

dos2unix ~/.zshrc

source .zshrc

git clone https://github.com/Unnamed10110/zsh-pwsh-wt.git

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

# sudo, config to root

sudo -i

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

exit

sudo cp ~/.zshrc /root/
sudo cp -rf ~/.oh-my-zsh /root/

sudo chown -R root:root /root/.zshrc /root/.oh-my-zsh


source .zshrc
clear
sleep 4
exit