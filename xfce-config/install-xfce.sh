#!/bin/bash

# ChaOS XFCE Installation and Configuration Script
# This script installs XFCE and applies ChaOS branding

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
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

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRANDING_DIR="$(dirname "$SCRIPT_DIR")/branding_assets"

print_status "Starting ChaOS XFCE installation..."

# Update package list
print_status "Updating package list..."
apt update

# Install XFCE and related packages
print_status "Installing XFCE desktop environment..."
apt install -y \
    xfce4 \
    xfce4-terminal \
    xfce4-screenshooter \
    xfce4-taskmanager \
    xfce4-power-manager \
    xfce4-notifyd \
    thunar \
    thunar-archive-plugin \
    lightdm \
    lightdm-gtk-greeter \
    plymouth \
    plymouth-themes \
    arc-theme \
    papirus-icon-theme

# Install minimal additional packages
print_status "Installing essential packages..."
apt install -y \
    firefox-esr \
    file-roller \
    gvfs \
    gvfs-backends \
    network-manager-gnome \
    menulibre

# Set up ChaOS branding directories
print_status "Setting up ChaOS branding..."
mkdir -p /usr/share/pixmaps/chaos
mkdir -p /usr/share/backgrounds/chaos
mkdir -p /usr/share/images/desktop-base
mkdir -p /etc/lightdm
mkdir -p /usr/share/plymouth/themes/chaos

# Copy branding assets
if [ -d "$BRANDING_DIR" ]; then
    print_status "Copying ChaOS branding assets..."
    
    # Copy wallpapers and backgrounds
    cp "$BRANDING_DIR/wallpaper.png" /usr/share/backgrounds/chaos/
    cp "$BRANDING_DIR/wallpaper.png" /usr/share/images/desktop-base/
    ln -sf /usr/share/images/desktop-base/wallpaper.png /usr/share/images/desktop-base/default
    
    if [ -f "$BRANDING_DIR/lightdm_background.png" ]; then
        cp "$BRANDING_DIR/lightdm_background.png" /usr/share/backgrounds/chaos/
    else
        cp "$BRANDING_DIR/wallpaper.png" /usr/share/backgrounds/chaos/lightdm_background.png
    fi
    
    if [ -f "$BRANDING_DIR/lock.png" ]; then
        cp "$BRANDING_DIR/lock.png" /usr/share/backgrounds/chaos/
    fi
    
    # Copy logos and icons
    cp "$BRANDING_DIR/logo.png" /usr/share/pixmaps/chaos/
    if [ -f "$BRANDING_DIR/chaos-icon.ico" ]; then
        cp "$BRANDING_DIR/chaos-icon.ico" /usr/share/pixmaps/chaos/
    fi
    if [ -f "$BRANDING_DIR/splash.png" ]; then
        cp "$BRANDING_DIR/splash.png" /usr/share/pixmaps/chaos/
    fi
    
    # Set proper permissions
    chmod 644 /usr/share/backgrounds/chaos/* 2>/dev/null || true
    chmod 644 /usr/share/pixmaps/chaos/* 2>/dev/null || true
    chmod 644 /usr/share/images/desktop-base/* 2>/dev/null || true
else
    print_warning "Branding assets directory not found at $BRANDING_DIR"
fi

# Configure LightDM for ChaOS branding
print_status "Configuring LightDM display manager..."
cat > /etc/lightdm/lightdm-gtk-greeter.conf << EOF
[greeter]
background=/usr/share/backgrounds/chaos/lightdm_background.png
theme-name=Arc-Dark
icon-theme-name=Papirus-Dark
font-name=Noto Sans 11
xft-antialias=true
xft-dpi=96
xft-hintstyle=slight
xft-rgba=rgb
show-indicators=~host;~spacer;~clock;~spacer;~layout;~session;~a11y;~power
show-clock=true
clock-format=%H:%M
EOF

# Enable LightDM
print_status "Enabling LightDM display manager..."
systemctl enable lightdm

# Create default XFCE configuration for new users
print_status "Creating default XFCE configuration..."
mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml

# XFCE Desktop configuration
# Create XFCE settings configuration for Arc-Dark theme
cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Arc-Dark"/>
    <property name="IconThemeName" type="string" value="Papirus-Dark"/>
    <property name="DoubleClickTime" type="uint" value="400"/>
    <property name="DoubleClickDistance" type="uint" value="5"/>
    <property name="DndDragThreshold" type="uint" value="8"/>
    <property name="CursorBlink" type="bool" value="true"/>
    <property name="CursorBlinkTime" type="uint" value="1200"/>
    <property name="SoundThemeName" type="string" value="default"/>
    <property name="EnableEventSounds" type="bool" value="false"/>
    <property name="EnableInputFeedbackSounds" type="bool" value="false"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="int" value="96"/>
    <property name="Antialias" type="int" value="1"/>
    <property name="Hinting" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="CanChangeAccels" type="bool" value="false"/>
    <property name="ColorPalette" type="string" value="black:white:gray50:red:purple:blue:light blue:green:yellow:orange:lavender:brown:goldenrod4:dodger blue:pink:light green:gray10:gray30:gray75:gray90"/>
    <property name="FontName" type="string" value="Noto Sans 10"/>
    <property name="IconSizes" type="string" value=""/>
    <property name="KeyThemeName" type="string" value=""/>
    <property name="ToolbarStyle" type="string" value="icons"/>
    <property name="ToolbarIconSize" type="uint" value="3"/>
    <property name="MenuImages" type="bool" value="true"/>
    <property name="ButtonImages" type="bool" value="true"/>
    <property name="MenuBarAccel" type="string" value="F10"/>
    <property name="CursorThemeName" type="string" value=""/>
    <property name="CursorThemeSize" type="uint" value="0"/>
    <property name="DecorationLayout" type="string" value="menu:minimize,maximize,close"/>
  </property>
</channel>
EOF

cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/images/desktop-base/wallpaper.png"/>
        </property>
        <property name="workspace1" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/images/desktop-base/wallpaper.png"/>
        </property>
        <property name="workspace2" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/images/desktop-base/wallpaper.png"/>
        </property>
        <property name="workspace3" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/images/desktop-base/wallpaper.png"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

# XFCE Panel configuration
cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=6;x=0;y=0"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="size" type="uint" value="30"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
        <value type="int" value="7"/>
        <value type="int" value="8"/>
        <value type="int" value="9"/>
        <value type="int" value="10"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="applicationsmenu"/>
    <property name="plugin-2" type="string" value="separator"/>
    <property name="plugin-3" type="string" value="directorymenu"/>
    <property name="plugin-4" type="string" value="separator"/>
    <property name="plugin-5" type="string" value="tasklist"/>
    <property name="plugin-6" type="string" value="separator"/>
    <property name="plugin-7" type="string" value="systray"/>
    <property name="plugin-8" type="string" value="pulseaudio"/>
    <property name="plugin-9" type="string" value="power-manager-plugin"/>
    <property name="plugin-10" type="string" value="clock"/>
  </property>
</channel>
EOF

# Create Plymouth theme for ChaOS
print_status "Creating Plymouth boot splash theme..."
mkdir -p /usr/share/plymouth/themes/chaos

# Create Plymouth theme configuration
cat > /usr/share/plymouth/themes/chaos/chaos.plymouth << EOF
[Plymouth Theme]
Name=ChaOS
Description=ChaOS Linux Boot Splash
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/chaos
ScriptFile=/usr/share/plymouth/themes/chaos/chaos.script
EOF

# Copy splash image for Plymouth
if [ -f "$BRANDING_DIR/splash.png" ]; then
    cp "$BRANDING_DIR/splash.png" /usr/share/plymouth/themes/chaos/
fi

# Create simple Plymouth script
cat > /usr/share/plymouth/themes/chaos/chaos.script << 'EOF'
# ChaOS Plymouth Script

# Set background color to black
Window.SetBackgroundTopColor (0, 0, 0);
Window.SetBackgroundBottomColor (0, 0, 0);

# Load splash image
splash_image = Image("splash.png");
splash_sprite = Sprite(splash_image);

# Center the splash image
splash_sprite.SetX((Window.GetWidth() - splash_image.GetWidth()) / 2);
splash_sprite.SetY((Window.GetHeight() - splash_image.GetHeight()) / 2);

# Progress indicator
progress = 0;

fun refresh_callback ()
{
    progress++;
}

Plymouth.SetRefreshFunction (refresh_callback);
EOF

# Set Plymouth theme
print_status "Setting Plymouth theme..."
plymouth-set-default-theme chaos
update-initramfs -u

print_success "ChaOS XFCE installation completed successfully!"
print_status "Next steps:"
print_status "1. Reboot the system to see Plymouth splash screen"
print_status "2. Log in to see XFCE with ChaOS branding"
print_status "3. LightDM will show ChaOS background on login screen"
print_warning "Note: If you're in a live environment, these changes will take effect after installation"
