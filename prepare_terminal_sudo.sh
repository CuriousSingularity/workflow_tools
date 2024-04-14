#!/usr/bin/env bash

# Update package lists and upgrade packages
sudo apt-get update -y
# sudo apt upgrade -y  # Uncomment to upgrade packages

# Install essential tools
sudo apt install -y \
    git \
    tmux \
    vim \
    ssh \
    speedtest-cli \
    htop \
    cpufrequtils \
    lm-sensors

# Load drivetemp module and set it to load on boot
sudo modprobe drivetemp
echo drivetemp | sudo tee -a /etc/modules

# Install fonts and update font cache
sudo apt install -y fontconfig
cd ~
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.0-RC/Meslo.zip
mkdir -p .local/share/fonts
unzip -o Meslo.zip -d .local/share/fonts
cd .local/share/fonts
rm *Windows*
cd ~ && rm Meslo.zip
fc-cache -fv

# Install Zsh and set it as the default shell
sudo apt install zsh -y
sudo apt-get install powerline fonts-powerline -y
sudo snap install lsd

# Install Oh My Zsh and plugins
rm -rf ~/.oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting --depth 1
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions --depth 1

# Configure Zsh and Oh My Zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
sed -i '/ZSH_THEME/d' ~/.zshrc

# Append custom Zsh configuration
cat << END >> ~/.zshrc
# custom
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="▶ "
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
END

# Set Zsh as the default shell
cat << END >> ~/.bashrc
if [ "\$SHELL" != "/usr/bin/zsh" ]; then
    export SHELL="/usr/bin/zsh"
    exec /usr/bin/zsh
fi
END

# Install fzf (fuzzy finder)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Configure Vim
cat << END > ~/.vimrc
" Vim settings
set showmatch
set ignorecase smartcase
set incsearch autowrite hidden mouse=a number hlsearch
END

# Configure custom commands
cat << END >> ~/.zshrc
[ -f ~/.customrc ] && source ~/.customrc
END

cat << END > ~/.customrc
# Custom aliases
alias ls="ls -alh"
alias gitd="git diff"
alias gits="git status"
alias gitp="git pull"
alias fzf="fzf -x --multi --cycle"
alias powersave="sudo cpufreq-set -g powersave"
alias powerperformance="sudo cpufreq-set -g performance"
END

# Final instructions for the user
echo ""
echo "Customrc configuration saved to ~/.customrc"
echo "Close and reopen the terminal to apply changes."
