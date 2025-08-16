#!/bin/bash

# ChaOS Custom Panel Configuration Script
# Configures XFCE panels according to ChaOS specifications

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

USER_HOME="$HOME"

print_status "Configuring ChaOS custom panels..."

# Create user XFCE config directories
mkdir -p "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml"

# Configure XFCE panels with ChaOS specifications
print_status "Setting up Panel-1 and Panel-2 with custom layout..."
cat > "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <value type="int" value="2"/>
    <!-- Panel-1: Top panel with ChaOS menu (no icon) -->
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=6;x=0;y=0"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="size" type="uint" value="38"/>
      <property name="background-style" type="uint" value="1"/>
      <property name="background-rgba" type="array">
        <value type="double" value="0.1"/>
        <value type="double" value="0.1"/>
        <value type="double" value="0.1"/>
        <value type="double" value="0.9"/>
      </property>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
        <value type="int" value="7"/>
        <value type="int" value="8"/>
      </property>
    </property>
    <!-- Panel-2: Custom layout - Row size 43, full length -->
    <property name="panel-2" type="empty">
      <property name="position" type="string" value="p=10;x=0;y=0"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="size" type="uint" value="43"/>
      <property name="background-style" type="uint" value="1"/>
      <property name="background-rgba" type="array">
        <value type="double" value="0.0"/>
        <value type="double" value="0.0"/>
        <value type="double" value="0.0"/>
        <value type="double" value="0.8"/>
      </property>
      <property name="plugin-ids" type="array">
        <value type="int" value="20"/>
        <value type="int" value="21"/>
        <value type="int" value="22"/>
        <value type="int" value="23"/>
        <value type="int" value="24"/>
        <value type="int" value="25"/>
        <value type="int" value="26"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <!-- Panel-1 Plugins -->
    <property name="plugin-1" type="string" value="applicationsmenu">
      <property name="button-title" type="string" value="ChaOS"/>
      <property name="show-button-title" type="bool" value="true"/>
      <property name="show-button-icon" type="bool" value="false"/>
    </property>
    <property name="plugin-2" type="string" value="separator">
      <property name="expand" type="bool" value="false"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-3" type="string" value="tasklist">
      <property name="grouping" type="uint" value="1"/>
      <property name="show-labels" type="bool" value="true"/>
      <property name="show-wireframes" type="bool" value="false"/>
    </property>
    <property name="plugin-4" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-5" type="string" value="systray">
      <property name="names-visible" type="array">
        <value type="string" value="networkmanager applet"/>
        <value type="string" value="thunar"/>
        <value type="string" value="vlc"/>
        <value type="string" value="discord"/>
        <value type="string" value="steam"/>
      </property>
      <property name="show-frame" type="bool" value="false"/>
    </property>
    <property name="plugin-6" type="string" value="pulseaudio">
      <property name="enable-keyboard-shortcuts" type="bool" value="true"/>
    </property>
    <property name="plugin-7" type="string" value="power-manager-plugin"/>
    <property name="plugin-8" type="string" value="clock">
      <property name="format" type="uint" value="4"/>
      <property name="mode" type="uint" value="2"/>
      <property name="show-frame" type="bool" value="false"/>
    </property>
    
    <!-- Panel-2 Plugins: Separator | Show Desktop | Terminal | File explorer | Browser | Directory Menu | Separator -->
    <property name="plugin-20" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-21" type="string" value="showdesktop"/>
    <property name="plugin-22" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="xfce4-terminal.desktop"/>
      </property>
    </property>
    <property name="plugin-23" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="thunar.desktop"/>
      </property>
    </property>
    <property name="plugin-24" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="firefox-esr.desktop"/>
      </property>
    </property>
    <property name="plugin-25" type="string" value="directorymenu">
      <property name="base-directory" type="string" value="/home"/>
    </property>
    <property name="plugin-26" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
  </property>
</channel>
EOF

print_success "Panel configuration completed!"
print_status "Panel-1: ChaOS menu (no icon), tasklist, system tray, clock"
print_status "Panel-2: Separator | Show Desktop | Terminal | File Explorer | Browser | Directory Menu | Separator"
print_status "Panel-2 size: 43px, full length"
