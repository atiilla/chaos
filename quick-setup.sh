#!/bin/bash

# ChaOS Quick Setup Script
# Quick setup for testing ChaOS theming on existing system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored output
print_banner() {
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                    ChaOS Quick Setup                          ║"
    echo "║              Testing ChaOS Theme Components                   ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_banner

print_status "ChaOS Quick Setup - Testing environment preparation"
print_warning "This script will install XFCE and apply ChaOS theming to test"
print_warning "Run this on a test system or virtual machine"

# Check if running as root for system-wide changes
if [[ $EUID -eq 0 ]]; then
    INSTALL_MODE="system"
    print_status "Running as root - will install system-wide"
else
    INSTALL_MODE="user"
    print_status "Running as user - will apply user-level customizations only"
fi

# Detect current desktop environment
if [ -n "$XDG_CURRENT_DESKTOP" ]; then
    print_status "Current desktop environment: $XDG_CURRENT_DESKTOP"
else
    print_status "No desktop environment detected"
fi

# Check if XFCE is available
if command -v xfce4-session &> /dev/null; then
    print_status "XFCE is already installed"
    XFCE_INSTALLED=true
else
    print_status "XFCE is not installed"
    XFCE_INSTALLED=false
fi

echo
echo "Choose setup option:"
echo "1) Full installation (requires root) - Install XFCE + ChaOS theming"
echo "2) User customization only - Apply ChaOS theme to existing XFCE"
echo "3) GRUB theme only (requires root) - Install ChaOS GRUB theme"
echo "4) Preview assets - Show what ChaOS looks like"
echo "5) Exit"
echo

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        if [[ $EUID -ne 0 ]]; then
            print_error "Option 1 requires root privileges"
            print_status "Run: sudo $0"
            exit 1
        fi
        
        print_step "Installing XFCE and ChaOS theming..."
        
        if [ -f "$SCRIPT_DIR/xfce-config/install-xfce.sh" ]; then
            print_status "Running XFCE installation script..."
            "$SCRIPT_DIR/xfce-config/install-xfce.sh"
        else
            print_error "XFCE installation script not found!"
            exit 1
        fi
        
        if [ -f "$SCRIPT_DIR/grub2-themes/ChaOS/install.sh" ]; then
            print_status "Installing GRUB theme..."
            "$SCRIPT_DIR/grub2-themes/ChaOS/install.sh"
        else
            print_warning "GRUB theme installer not found, skipping..."
        fi
        
        print_success "Full installation completed!"
        print_status "Log out and log back in to XFCE to see ChaOS theming"
        ;;
        
    2)
        if [[ $EUID -eq 0 ]]; then
            print_error "Option 2 should NOT be run as root"
            print_status "Run this script as a regular user"
            exit 1
        fi
        
        if [ "$XFCE_INSTALLED" = false ]; then
            print_error "XFCE is not installed. Please install XFCE first or choose option 1"
            exit 1
        fi
        
        print_step "Applying ChaOS desktop customization..."
        
        if [ -f "$SCRIPT_DIR/xfce-config/customize-desktop.sh" ]; then
            "$SCRIPT_DIR/xfce-config/customize-desktop.sh"
        else
            print_error "Desktop customization script not found!"
            exit 1
        fi
        
        print_success "Desktop customization completed!"
        ;;
        
    3)
        if [[ $EUID -ne 0 ]]; then
            print_error "Option 3 requires root privileges"
            print_status "Run: sudo $0"
            exit 1
        fi
        
        print_step "Installing ChaOS GRUB theme..."
        
        if [ -f "$SCRIPT_DIR/grub2-themes/ChaOS/install.sh" ]; then
            "$SCRIPT_DIR/grub2-themes/ChaOS/install.sh"
        else
            print_error "GRUB theme installer not found!"
            exit 1
        fi
        
        print_success "GRUB theme installation completed!"
        print_status "Reboot to see the new GRUB theme"
        ;;
        
    4)
        print_step "Previewing ChaOS assets..."
        
        if [ -d "$SCRIPT_DIR/branding_assets" ]; then
            print_status "Available ChaOS branding assets:"
            ls -la "$SCRIPT_DIR/branding_assets/"
            
            echo
            print_status "Asset descriptions:"
            echo "  - wallpaper.png: Desktop background"
            echo "  - grub_background.png: GRUB boot menu background"
            echo "  - lightdm_background.png: Login screen background"
            echo "  - splash.png: Boot splash image"
            echo "  - logo.png: ChaOS logo"
            echo "  - chaos-icon.ico: System icon"
            echo "  - lock.png: Lock screen background"
            
            if command -v identify &> /dev/null; then
                echo
                print_status "Image information:"
                for img in "$SCRIPT_DIR/branding_assets/"*.png; do
                    if [ -f "$img" ]; then
                        echo "  $(basename "$img"): $(identify -format "%wx%h" "$img")"
                    fi
                done
            fi
            
            if command -v eog &> /dev/null || command -v feh &> /dev/null || command -v display &> /dev/null; then
                echo
                read -p "Would you like to view the wallpaper? (y/n): " view_wallpaper
                if [[ $view_wallpaper =~ ^[Yy]$ ]]; then
                    if command -v eog &> /dev/null; then
                        eog "$SCRIPT_DIR/branding_assets/wallpaper.png" &
                    elif command -v feh &> /dev/null; then
                        feh "$SCRIPT_DIR/branding_assets/wallpaper.png" &
                    elif command -v display &> /dev/null; then
                        display "$SCRIPT_DIR/branding_assets/wallpaper.png" &
                    fi
                fi
            fi
        else
            print_error "Branding assets directory not found!"
            exit 1
        fi
        ;;
        
    5)
        print_status "Exiting..."
        exit 0
        ;;
        
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

echo
print_success "ChaOS Quick Setup completed!"

if [ "$choice" = "1" ] || [ "$choice" = "2" ]; then
    echo
    print_status "Next steps:"
    print_status "1. Log out of current session"
    print_status "2. Select XFCE session at login screen"
    print_status "3. Log in to see ChaOS theming"
    
    if [ "$choice" = "1" ]; then
        print_status "4. Reboot to see GRUB theme and Plymouth splash"
    fi
fi

if [ "$choice" = "3" ]; then
    echo
    print_status "Reboot your system to see the new GRUB theme"
fi

print_status "For full ISO creation, run: sudo ./build-chaos.sh"
