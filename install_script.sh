#!/bin/bash

# Function to check if the last command executed successfully
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed."
        exit 1
    fi
}

# Function to execute command with error handling
execute_command() {
    echo "Command executing: $2" && eval "$1" && echo "Command executed: $2" || echo "Failed to execute command: $2"
}

# Update repository information and installed packages
execute_command "sudo zypper ref" "Update repository information"
execute_command "sudo zypper update" "Update installed packages"

# Define the desired swappiness value
SWAPPINESS_VALUE=10

# Check the current swappiness value
CURRENT_SWAPPINESS=$(cat /proc/sys/vm/swappiness)
echo "Current swappiness value: $CURRENT_SWAPPINESS"

# Update the swappiness value if it's not already set to the desired value
if [ "$CURRENT_SWAPPINESS" != "$SWAPPINESS_VALUE" ]; then
    echo "Updating swappiness value to $SWAPPINESS_VALUE"
    echo "vm.swappiness=$SWAPPINESS_VALUE" | sudo tee -a /etc/sysctl.conf > /dev/null
    sudo sysctl -p
else
    echo "Swappiness value is already set to $SWAPPINESS_VALUE"
fi

cat > AnyDesk-OpenSUSE.repo << "EOF"
[anydesk]
name=AnyDesk OpenSUSE - stable
baseurl=http://rpm.anydesk.com/opensuse/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF

# Add repositories
echo "Adding repositories..."
execute_command "sudo zypper addrepo http://dl.google.com/linux/chrome/rpm/stable/x86_64 google-chrome" "Google Chrome" # Checked
execute_command "sudo zypper addrepo --repo AnyDesk-OpenSUSE.repo" "AnyDesk" # Checked
execute_command "sudo rpm --import https://keys.anydesk.com/repos/RPM-GPG-KEY" "Anydesk" # Checked
execute_command "sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc" "Visual Studio Code" # Checked
execute_command "sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc" "Brave Browser GPG key" # Checked
execute_command "sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo" "Brave Browser" #Checked
execute_command "sudo zypper addrepo https://download.opensuse.org/repositories/home:cabelo:innovators/openSUSE_Tumbleweed/home:cabelo:innovators.repo" "PyCharm Community Edition" # Checked
execute_command "sudo zypper addrepo https://download.opensuse.org/repositories/home:deltafox/openSUSE_Tumbleweed/home:deltafox.repo" "Ferdium" # Checked
execute_command "sudo zypper addrepo https://download.opensuse.org/repositories/home:ahjolinna/openSUSE_Tumbleweed/home:ahjolinna.repo" "Firefox Developer Edition" # Checked
execute_command "sudo zypper addrepo https://download.opensuse.org/repositories/home:ecsos/openSUSE_Tumbleweed/home:ecsos.repo" "Android Studio | FileZilla | Dbeaver" # Checked

# Removing Anydesk Repo
execute_command "rm -rf AnyDesk-OpenSUSE.repo" "Removing Anydesk Repo"

# Import Google Chrome signing key
echo "Importing Google Chrome signing key & Removing Key..."
execute_command "wget https://dl.google.com/linux/linux_signing_key.pub" "Google Chrome signing key Download"
execute_command "sudo rpm --import linux_signing_key.pub" "Google Chrome signing key Import"

# Check if the import was successful, if not, execute the fallback
diff <(gpg --show-keys <(sudo rpm -qi gpg-pubkey-7fac5991-* gpg-pubkey-d38b4796-*) 2> /dev/null) \
     <(gpg --show-keys linux_signing_key.pub) > /dev/null \
     && echo "Import successful" || echo "Import failed"
sudo rpm -e gpg-pubkey-7fac5991-* gpg-pubkey-d38b4796-*
sudo rpm --import linux_signing_key.pub
execute_command "rm -rf linux_signing_key.pub" "Removing Anydesk Repo"

# Import Visual Studio Code repository configuration
echo "Importing Visual Studio Code repository configuration..."
execute_command "execute_command 'sudo sh -c "echo -e [code]\\nname=Visual Studio Code\\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\\nenabled=1\\ntype=rpm-md\\ngpgcheck=1\\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc > /etc/zypp/repos.d/vscode.repo"' "Visual Studio Code repository configuration"" "Visual Studio Code repository configuration"

# Refresh repositories
echo "Refreshing repositories..."
execute_command "sudo zypper ref" "Refresh repositories"

# Uninstall Discover
execute_command "sudo zypper remove discover" "Uninstall Discover"

# Install software packages one by one
echo "Installing software packages..."
execute_command "sudo zypper install power-profiles-daemon" "Installing Power Profiles Daemon"
execute_command "sudo zypper install google-chrome-stable" "Google Chrome"
execute_command "sudo zypper install anydesk" "AnyDesk"
execute_command "sudo zypper install peek" "Peek"
execute_command "sudo zypper install ferdium" "Ferdium"
execute_command "sudo zypper install remmina" "Remmina"
execute_command "sudo zypper install filezilla" "FileZilla"
execute_command "sudo zypper install dbeaver" "Dbeaver"
execute_command "sudo zypper install meld" "Meld"
execute_command "sudo zypper install deluge" "Deluge"
execute_command "sudo zypper install brave-browser" "Brave Browser"
execute_command "sudo zypper install firefox-dev" "Firefox Developer Edition"
execute_command "sudo zypper install pycharm-community" "PyCharm Community Edition"
execute_command "sudo zypper install keepassxc" "KeePassXC"
execute_command "sudo zypper install nodejs20" "Node.js 20"
execute_command "sudo zypper install mariadb-server" "MariaDB Server"
execute_command "sudo zypper install mozilla-nss-tools jq xsel" "Mozilla NSS Tools"
execute_command "sudo zypper install code" "Visual Studio Code"
execute_command "sudo zypper install android-studio" "Android Studio"
execute_command "sudo zypper install php8 php8-pear php8-devel php8-bcmath php8-gd php8-mbstring php8-zip php8-curl php8-mysql php8-openssl php8-posix php8-intl php8-fpm php8-pdo php8-bcmath php8-dba php8-imagick php8-devel php8-pgsql php8-fileinfo php8-exif" "PHP 8"

# Clone Powerline fonts repository
echo "Cloning Powerline fonts repository..."
execute_command "git clone https://github.com/powerline/fonts.git" "Powerline fonts repository"

# Install Powerline fonts
echo "Installing Powerline fonts..."
execute_command "(cd fonts && ./install.sh)" "Powerline fonts"
execute_command "rm -rf fonts" "Removing Powerline fonts"

# Install Composer
echo "Installing Composer..."
execute_command "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"" "Composer setup"
execute_command "php -r \"if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); exit(1); } echo PHP_EOL;\"" "Composer setup verification"
execute_command "php composer-setup.php" "Composer installation"
execute_command "unlink composer-setup.php" "Remove Composer setup file"
execute_command "sudo mv composer.phar /usr/local/bin/composer" "Moving Composer Globally"
echo 'export PATH="$HOME/.composer/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
composer -v

# Install Valet for Linux
echo "Installing Valet for Linux..."
execute_command "composer global require cpriego/valet-linux" "Valet for Linux installation"
execute_command "valet install" "Valet for Linux configuration"

# Enable and start MariaDB service
echo "Enabling and starting MariaDB service..."
execute_command "sudo systemctl enable --now mariadb" "MariaDB service"

# Secure MariaDB installation
echo "Securing MariaDB installation..."
execute_command "sudo mysql_secure_installation" "MariaDB secure installation"
