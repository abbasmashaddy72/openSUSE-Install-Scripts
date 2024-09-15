# openSUSE System Setup Automation

This project contains a set of bash scripts to automate the installation and configuration of packages, system settings, services, and development tools on openSUSE. It simplifies the process of setting up your system for development, managing services, installing essential software, and customizing Zsh.

## Overview

The project includes three main scripts:

1. **Extra Configuration Script (`extra_config.sh`)**  
   This script handles Git setup, repository cloning, configuring system services (Nginx and AppArmor), and other extra configurations like Valet parking and system services.

2. **Installation Script (`install_script.sh`)**  
   This script installs various software packages, adds repositories, imports GPG keys, and performs system configuration tasks (e.g., swappiness settings, installing PHP, Chrome, Brave, and more).

3. **Zsh Installation and Configuration Script (`zsh_install.sh`)**  
   This script installs Zsh, sets it as the default shell, installs Oh My Zsh, and configures Zsh plugins and themes for enhanced productivity.

---

## Setup Instructions

### Step 1: Make Scripts Executable

Before running the scripts, make them executable:

```bash
chmod +x extra_config.sh install_script.sh zsh_install.sh
```

### Step 2: Run the Scripts

Run each script individually to set up the system:

1. **Extra Configuration Script**:
   This script handles Git configuration, service file modifications, repository cloning, and Valet setup for Linux.

   ```bash
   ./extra_config.sh
   ```

2. **Installation Script**:
   This script handles package installations, repository additions, swappiness configuration, and software installations.

   ```bash
   ./install_script.sh
   ```

3. **Zsh Installation and Configuration Script**:
   This script installs Zsh, Oh My Zsh, and additional plugins and themes for better terminal productivity.

   ```bash
   ./zsh_install.sh
   ```

---

## Script Descriptions

### 1. `extra_config.sh`

This script performs extra configurations like:

- **Git Configuration**: Configures Git credentials and user information globally.
- **Repository Cloning**: Clones repositories into specific directories.
- **Service Modifications**: Modifies Nginx and AppArmor configurations.
- **Service Management**: Restarts services and checks service status.
- **Valet Parking**: Parks Valet in specific directories for easy local development.

#### Usage:

```bash
bash extra_config.sh
```

---

### 2. `install_script.sh`

This script installs a variety of software packages and performs system configurations like:

- **Repository Management**: Adds repositories for software like Google Chrome, Brave Browser, AnyDesk, Visual Studio Code, and more.
- **Swappiness Configuration**: Adjusts the system's swappiness value for better memory management.
- **Software Installation**: Installs packages including Google Chrome, AnyDesk, PyCharm, Android Studio, MariaDB, and PHP 8.

#### Usage:

```bash
bash install_script.sh
```

---

### 3. `zsh_install.sh`

This script handles the installation and configuration of Zsh, including:

- **Installing Zsh**: Ensures Zsh is installed and sets it as the default shell.
- **Oh My Zsh**: Installs Oh My Zsh, a popular Zsh framework for managing Zsh configuration.
- **Plugins and Themes**: Installs useful plugins like `zsh-autosuggestions`, `zsh-syntax-highlighting`, and configures the `agnoster` theme for an improved terminal experience.

#### Usage:

```bash
bash zsh_install.sh
```

---

## Detailed Script Breakdown

### `extra_config.sh`

This script includes the following key functionalities:

- **Git Store Credentials**: Configures Git to store credentials for ease of use.
- **Clone Repositories**: Automatically clones specific repositories into organized directories under `~/Documents/Project Sites/`.
- **System Services**: Modifies Nginx service files to disable ProtectHome and updates AppArmor configurations for PHP-FPM.
- **Valet**: Ensures Valet is installed and parks it in the appropriate directories.

### `install_script.sh`

This script:

- **Adds Repositories**: Adds repositories for Google Chrome, Brave Browser, AnyDesk, PyCharm, Firefox Developer Edition, and more.
- **Installs Essential Packages**: Installs software like Google Chrome, AnyDesk, FileZilla, DBeaver, MariaDB, PHP 8, and more.
- **Manages Repositories and Keys**: Imports necessary GPG keys and manages repository configuration.
- **Configures System Settings**: Adjusts swappiness for better memory management, refreshes repositories, and ensures system services are up to date.

### `zsh_install.sh`

This script:

- **Installs Zsh**: Ensures Zsh is installed and sets it as the default shell.
- **Installs Oh My Zsh**: Automates the installation of Oh My Zsh, which greatly enhances Zsh.
- **Installs Plugins**: Adds useful Zsh plugins like `zsh-autosuggestions`, `zsh-syntax-highlighting`, and `zsh-autocomplete` for enhanced command-line usability.
- **Configures `.zshrc`**: Automatically configures the `.zshrc` file with useful plugins and changes the default theme to `agnoster`.

---

## Conclusion

These scripts will help you automate the setup of openSUSE for development and general productivity. They install essential tools, configure system services, and enhance the terminal environment with Zsh and useful plugins.

Make sure to review and customize the scripts according to your requirements before running them. Let me know if you need any further adjustments or if you'd like to contribute!

---

Maintained by [Syed Kounain Abbas Rizvi](https://github.com/abbasmashaddy72).
