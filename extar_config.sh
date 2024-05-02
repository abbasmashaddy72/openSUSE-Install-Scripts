#!/bin/bash

# Function to execute command with error handling
execute_command() {
    echo "Command executing: $2" && eval "$1" && echo "Command executed: $2" || echo "Failed to execute command: $2"
}

execute_command "git config --global credential.helper store" "Git Store Credential"
execute_command "sudo systemctl restart nginx.service php-fpm.service apparmor.service" "Restart System Services"

# Cloning Projects

# Function to check if the last command executed successfully
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed."
        exit 1
    fi
}

# Base directory for project sites
base_dir="$HOME/Documents/Project Sites"

# Function to clone a repository into the specified directory
clone_repository() {
    local repo_url="$1"
    local directory="$2"

    echo "Cloning repository $repo_url into directory $directory..."
    git clone "$repo_url" "$directory"
    check_status "Cloning repository $repo_url"
}

# Clients
clone_repository "https://github.com/abbasmashaddy72/aim_quiz" "$base_dir/Clients/aim-quiz"
clone_repository "https://github.com/abbasmashaddy72/sonu_motors" "$base_dir/Clients/sonu-motors"

# Personal
clone_repository "https://github.com/abbasmashaddy72/aim-mumbai" "$base_dir/Personal/aim-mumbai"
clone_repository "https://github.com/abbasmashaddy72/cms" "$base_dir/Personal/cms"
clone_repository "https://github.com/abbasmashaddy72/info" "$base_dir/Personal/info"
clone_repository "https://github.com/abbasmashaddy72/old-quiz" "$base_dir/Personal/old-quiz"
clone_repository "https://github.com/abbasmashaddy72/project-management" "$base_dir/Personal/project-management"

# GIT ReadMe
clone_repository "https://github.com/abbasmashaddy72/abbasmashaddy72" "$base_dir/GIT ReadMe/abbasmashaddy72"

# Samples
# No repositories to clone under Samples

# Testing
# No repositories to clone under Testing

# Setting Nginx Service File ProtectHome to False
# Path to the nginx.service file
service_file="/usr/lib/systemd/system/nginx.service"

# Check if the file exists
if [ ! -f "$service_file" ]; then
    echo "Error: $service_file does not exist."
    exit 1
fi

# Check if ProtectHome is already set to false
if grep -q "^ProtectHome=false" "$service_file"; then
    echo "ProtectHome is already set to false in $service_file."
else
    # If ProtectHome is not set to false, replace it with false
    sudo sed -i 's/^ProtectHome=.*/ProtectHome=false/' "$service_file"
    echo "ProtectHome set to false in $service_file."
fi

# Check Apparmor PHPFPM Service:

# Define the path to the apparmor file
apparmor_file="/etc/apparmor.d/php-fpm"

# Function to check if a specific line exists in the apparmor file
check_line() {
    local line="$1"
    if grep -q "$line" "$apparmor_file"; then
        echo "Line '$line' is correctly configured."
    else
        echo "Line '$line' is missing or incorrectly configured."
        # Exit the script or handle the error as needed
        exit 1
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

# Restart apparmor service
echo "Restarting apparmor service..."
sudo systemctl restart apparmor.service
