#!/bin/bash

# Function to execute command with error handling
execute_command() {
    local command="$1"
    local description="$2"

    echo "Command executing: $description"
    if eval "$command"; then
        echo "Command executed: $description"
    else
        echo "Failed to execute command: $description"
        exit 1
    fi
}

execute_command "git config --global credential.helper store" "Git Store Credential"
execute_command "git config --global user.name \"abbasmashaddy72\"" "Git UserName"
execute_command "git config --global user.email abbasmashaddy72@gmail.com" "Git Email"

# Function to clone a repository into the specified directory
clone_repository() {
    local repo_url="$1"
    local directory="$2"

    if [ -d "$directory" ]; then
        echo "Directory $directory already exists."
        return
    fi

    echo "Cloning repository $repo_url into directory $directory..."
    git clone "$repo_url" "$directory"
    check_status "Cloning repository $repo_url"
}

# Base directory for project sites
base_dir="$HOME/Documents/Project Sites"

# Clients
clone_repository "https://github.com/abbasmashaddy72/aim_quiz" "$base_dir/Clients/aim-quiz"
clone_repository "https://github.com/abbasmashaddy72/sonu_motors" "$base_dir/Clients/sonu-motors"

# Personal
clone_repository "https://github.com/abbasmashaddy72/aim-mumbai" "$base_dir/Personal/aim-mumbai"
clone_repository "https://github.com/abbasmashaddy72/cms" "$base_dir/Personal/cms"
clone_repository "https://github.com/abbasmashaddy72/quiz" "$base_dir/Personal/old-quiz"
clone_repository "https://github.com/abbasmashaddy72/project-management" "$base_dir/Personal/project-management"

# Create info folder with index.php showing PHP info
info_dir="$base_dir/Personal/info"
if [ ! -d "$info_dir" ]; then
    mkdir -p "$info_dir"
fi

# Create index.php file with PHP info
echo "<?php phpinfo();" > "$info_dir/index.php"

# GIT ReadMe
clone_repository "https://github.com/abbasmashaddy72/abbasmashaddy72" "$base_dir/GIT ReadMe/abbasmashaddy72"

# Samples
echo "Copying samples..."
cp -r "/run/media/abbasmashaddy72/My Passport 4TB/Code Base/Samples/"* "$base_dir/Samples"

# Setting Nginx Service File ProtectHome to False
# Path to the nginx.service file
service_file="/usr/lib/systemd/system/nginx.service"

# Check if ProtectHome is already set to false
if ! grep -q "^ProtectHome=false" "$service_file"; then
    # If ProtectHome is not set to false, replace it with false
    sudo sed -i 's/^ProtectHome=.*/ProtectHome=false/' "$service_file"
    echo "ProtectHome set to false in $service_file."
fi

# Restarting Daemon
execute_command "sudo systemctl daemon-reload" "Reloading Daemon"

# Check AppArmor PHPFPM Service:

# Define the path to the apparmor file
apparmor_file="/etc/apparmor.d/php-fpm"

# Function to check if a specific line exists in the apparmor file
check_line() {
    local line="$1"
    if grep -q "$line" "$apparmor_file"; then
        echo "Line '$line' is correctly configured."
    else
        echo "Line '$line' is missing or incorrectly configured."
        apparmor_lines+="\n$line"
    fi
}

# Lines to check in the apparmor profile
check_line "abi <abi/3.0>"
check_line "include <tunables/global>"
check_line "include <abstractions/base>"
check_line "include <abstractions/nameservice>"
check_line "include <abstractions/openssl>"
check_line "include <abstractions/php>"
check_line "include <abstractions/ssl_certs>"
check_line "include if exists <local/php-fpm>"
check_line "include if exists <php-fpm.d>"
check_line "capability chown,"
check_line "capability dac_override,"
check_line "capability dac_read_search,"
check_line "capability kill,"
check_line "capability net_admin,"
check_line "capability setgid,"
check_line "capability setuid,"
check_line "signal send peer=php-fpm//*,"
check_line "deny / rw,"
check_line "/usr/libexec/libheif/ r,"
check_line "/usr/sbin/php-fpm* rix,"
check_line "/var/log/php*-fpm.log rw,"
check_line "@{PROC}/@{pid}/attr/{apparmor/,}current rw,"
check_line "@{run}/php*-fpm.pid rw,"
check_line "@{run}/php{,-fpm}/php*-fpm.pid rw,"
check_line "@{run}/php{,-fpm}/php*-fpm.sock rwlk,"
check_line 'owner "/home/abbasmashaddy72/Documents/Projects Sites/**" rw,'
check_line 'owner /etc/ImageMagick-7/log.xml r,'
check_line 'owner /etc/ImageMagick-7/policy.xml r,'
check_line 'owner /home/abbasmashaddy72/.composer/vendor/cpriego/** rw,'
check_line 'owner /home/abbasmashaddy72/.valet/** rw,'
check_line 'owner /usr/share/ImageMagick-7/english.xml r,'
check_line 'owner /usr/share/ImageMagick-7/locale.xml r,'
check_line "change_profile -> php-fpm//*,"

# If any lines were missing or incorrectly configured, add them at the end
if [ -n "$apparmor_lines" ]; then
    echo -e "\nAdding missing or incorrectly configured lines to $apparmor_file"
    # Remove the existing closing brace
    sed -i '$d' "$apparmor_file"
    # Append missing lines
    echo -e "$apparmor_lines" | sudo tee -a "$apparmor_file" > /dev/null
    # Re-add the closing brace
    echo "}" | sudo tee -a "$apparmor_file" > /dev/null
fi

# Restart apparmor service
echo "Restarting Services..."
execute_command "sudo systemctl restart nginx.service php-fpm.service apparmor.service" "Restart System Services"

# Re Installing Valet
execute_command "valet install" "Installing Valet"

# Checking Service Status
execute_command "sudo systemctl status nginx.service php-fpm.service apparmor.service" "Status of System Services"

# Navigate to Clients directory and execute valet park
cd "$base_dir/Clients" || exit
execute_command "valet park" "Executing Valet Park for Clients"

# Navigate to Personal directory and execute valet park
cd "$base_dir/Personal" || exit
execute_command "valet park" "Executing Valet Park for Personal"

# Ensure Testing directory is created
mkdir -p "$base_dir/Testing"

# Navigate to Testing directory and execute valet park
cd "$base_dir/Testing" || exit
execute_command "valet park" "Executing Valet Park for Testing"
