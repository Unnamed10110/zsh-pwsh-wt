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

chmod 755 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_brew
chmod -R go-w /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_brew
sudo chmod go-w /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_brew

#root
#!/bin/bash

set -e  # Exit on error

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install essential packages
apt update && apt install -y \
  fzf bat ripgrep zsh curl git neovim dos2unix \
  wget nmap tree build-essential python3-pip jq \
  gnupg libgl1

# Clean up .zshrc formatting
dos2unix ~/.zshrc

# Set compfix bypass and compinit
echo 'ZSH_DISABLE_COMPFIX=true' >> ~/.zshrc
echo 'fpath=(\${fpath:#/home/linuxbrew/.linuxbrew/share/zsh/site-functions})' >> ~/.zshrc
echo 'autoload -Uz compinit && compinit' >> ~/.zshrc

# Source zshrc now
source ~/.zshrc || true

# Clone and apply personal config
cd ~
git clone https://github.com/Unnamed10110/zsh-pwsh-wt.git

cp -rf zsh-pwsh-wt/kaliPersonalConfig/automate_zsh.sh .
cp -rf zsh-pwsh-wt/kaliPersonalConfig/debian/Home/. .

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone and set up plugins
git clone https://github.com/z-shell/H-S-MW.git
cp -rf H-S-MW ~/.oh-my-zsh/custom/plugins/H-S-MW/
rm -rf H-S-MW

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
git clone https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/custom/plugins/zsh-autocomplete

# Copy custom Zsh theme
cp -f zsh-pwsh-wt/kaliPersonalConfig/debian/Home/jonathan.zsh-theme ~/.oh-my-zsh/themes/

# Add Sublime Text repo and install
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list
apt update && apt install -y sublime-text

# Optional: link Zsh history (replace YOUR_USERNAME with actual name)
ln -sf /home/unnamed10110/.zsh_history /root/.zsh_history

# Fix insecure compinit warning for Homebrew completions
chmod go-w /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_brew || true
chmod -R go-w /home/linuxbrew/.linuxbrew/share/zsh/site-functions/ || true

echo "✅ Root Zsh environment setup complete!"
