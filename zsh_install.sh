#!/bin/bash

# Check if Zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "Zsh is not installed. Installing..."
    sudo zypper install -y zsh
else
    echo "Zsh is already installed."
fi

# Setting Default shell
chsh -s /usr/bin/zsh;

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Clone zsh-autosuggestions
echo "Cloning zsh-autosuggestions..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions already exists."
fi

# Clone zsh-syntax-highlighting
echo "Cloning zsh-syntax-highlighting..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting already exists."
fi

# Clone zsh-autocomplete
echo "Cloning zsh-autocomplete..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete" ]; then
    git clone https://github.com/marlonrichert/zsh-autocomplete ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
else
    echo "zsh-autocomplete already exists."
fi

# Set ZSH_THEME to "agnoster" in ~/.zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc

# List of plugins to check and add if not present
plugins=('colorize' 'command-not-found' 'composer' 'laravel' 'npm' 'safe-paste' 'suse' 'git' 'zsh-autosuggestions' 'zsh-autocomplete' 'zsh-syntax-highlighting')

# Loop through each plugin and add if not present
for plugin in "${plugins[@]}"; do
    if ! awk -v pat="^plugins=.*${plugin}" '$0 ~ pat { found = 1; exit } END { exit !found }' ~/.zshrc; then
        echo "Adding $plugin to ~/.zshrc..."
        sed -i "/^plugins=(/ s/)$/ ${plugin})/" ~/.zshrc
    else
        echo "$plugin is already configured in ~/.zshrc."
    fi
done

# Add colorize configuration to ~/.zshrc (if not already present)
if ! grep -q "^export ZSH_COLORIZE_TOOL=" ~/.zshrc; then
    echo "Adding colorize configuration to ~/.zshrc..."
    cat <<EOF >> ~/.zshrc
# Set the syntax highlighter tool (optional)
export ZSH_COLORIZE_TOOL=chroma

# Set the style (optional)
export ZSH_COLORIZE_STYLE="colorful"

# Set the chroma formatter (optional)
export ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
EOF
else
    echo "colorize configuration is already present in ~/.zshrc."
fi
