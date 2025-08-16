#!/bin/bash

# ChaOS Desktop Customization Script
# Applies ChaOS branding to an existing XFCE installation for current user

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

# Don't run as root for user customization
if [[ $EUID -eq 0 ]]; then
   print_error "This script should NOT be run as root"
   print_status "Run this script as the user you want to customize"
   exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"

print_status "Customizing XFCE desktop for user: $(whoami)"

# Create user XFCE config directories
mkdir -p "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
mkdir -p "$USER_HOME/.config/xfce4/desktop"
mkdir -p "$USER_HOME/.local/share/applications"

# Set ChaOS wallpaper
print_status "Setting ChaOS wallpaper..."
cat > "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml" << 'EOF'
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
  <property name="desktop-icons" type="empty">
    <property name="style" type="int" value="2"/>
    <property name="file-icons" type="empty">
      <property name="show-home" type="bool" value="true"/>
      <property name="show-filesystem" type="bool" value="true"/>
      <property name="show-removable" type="bool" value="true"/>
      <property name="show-trash" type="bool" value="true"/>
    </property>
  </property>
</channel>
EOF

# Configure XFCE panel with ChaOS branding - Dock style layout
print_status "Configuring ChaOS custom panel layout..."
cat > "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <value type="int" value="2"/>
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
        <value type="int" value="9"/>
      </property>
    </property>
    <property name="panel-2" type="empty">
      <property name="position" type="string" value="p=10;x=0;y=0"/>
      <property name="length" type="uint" value="60"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="size" type="uint" value="48"/>
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
        <value type="int" value="27"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <!-- Top Panel Plugins -->
    <property name="plugin-1" type="string" value="applicationsmenu">
      <property name="button-title" type="string" value="ChaOS"/>
      <property name="button-icon" type="string" value="/usr/share/pixmaps/chaos/logo.png"/>
      <property name="show-button-title" type="bool" value="true"/>
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
      <property name="style" type="uint" value="1"/>
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
    <property name="plugin-8" type="string" value="notification-plugin"/>
    <property name="plugin-9" type="string" value="clock">
      <property name="format" type="uint" value="4"/>
      <property name="mode" type="uint" value="2"/>
      <property name="show-frame" type="bool" value="false"/>
    </property>
    
    <!-- Bottom Dock Panel Plugins -->
    <property name="plugin-20" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="exo-file-manager.desktop"/>
      </property>
    </property>
    <property name="plugin-21" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="exo-terminal-emulator.desktop"/>
      </property>
    </property>
    <property name="plugin-22" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="exo-web-browser.desktop"/>
      </property>
    </property>
    <property name="plugin-23" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="chaos-about.desktop"/>
      </property>
    </property>
    <property name="plugin-24" type="string" value="separator">
      <property name="expand" type="bool" value="false"/>
      <property name="style" type="uint" value="1"/>
    </property>
    <property name="plugin-25" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="exo-mail-reader.desktop"/>
      </property>
    </property>
    <property name="plugin-26" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="chaos-system-monitor.desktop"/>
      </property>
    </property>
    <property name="plugin-27" type="string" value="showdesktop"/>
  </property>
</channel>
EOF

# Configure window manager with cool effects
print_status "Configuring ChaOS window manager with effects..."
cat > "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Default"/>
    <property name="title_font" type="string" value="Noto Sans Bold 9"/>
    <property name="button_layout" type="string" value="O|SHMC"/>
    <property name="click_to_focus" type="bool" value="true"/>
    <property name="focus_delay" type="int" value="100"/>
    <property name="raise_delay" type="int" value="100"/>
    <property name="raise_on_focus" type="bool" value="false"/>
    <property name="raise_on_click" type="bool" value="true"/>
    <property name="use_compositing" type="bool" value="true"/>
    <property name="placement_ratio" type="int" value="20"/>
    <property name="workspace_count" type="int" value="6"/>
    <property name="wrap_windows" type="bool" value="true"/>
    <property name="wrap_workspaces" type="bool" value="true"/>
    <property name="zoom_desktop" type="bool" value="true"/>
    <property name="show_frame_shadow" type="bool" value="true"/>
    <property name="show_popup_shadow" type="bool" value="true"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="snap_to_windows" type="bool" value="true"/>
    <property name="snap_width" type="int" value="10"/>
    <property name="double_click_action" type="string" value="maximize"/>
    <property name="easy_click" type="string" value="Alt"/>
    <property name="horiz_scroll_opacity" type="bool" value="false"/>
    <property name="borderless_maximize" type="bool" value="true"/>
    <property name="tile_on_move" type="bool" value="true"/>
    <property name="prevent_focus_stealing" type="bool" value="false"/>
    <property name="activate_action" type="string" value="bring"/>
  </property>
</channel>
EOF

# Configure advanced keyboard shortcuts
print_status "Setting up ChaOS keyboard shortcuts..."
cat > "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-keyboard-shortcuts" version="1.0">
  <property name="commands" type="empty">
    <property name="default" type="empty">
      <property name="&lt;Alt&gt;F1" type="string" value="xfce4-popup-applicationsmenu"/>
      <property name="&lt;Alt&gt;F2" type="string" value="xfce4-appfinder --collapsed"/>
      <property name="&lt;Alt&gt;F3" type="string" value="xfce4-appfinder"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;Delete" type="string" value="xflock4"/>
      <property name="XF86Display" type="string" value="xfce4-display-settings --minimal"/>
      <property name="&lt;Super&gt;p" type="string" value="xfce4-display-settings --minimal"/>
      <property name="&lt;Primary&gt;Escape" type="string" value="xfdesktop --menu"/>
      <property name="XF86WWW" type="string" value="exo-open --launch WebBrowser"/>
      <property name="XF86Mail" type="string" value="exo-open --launch MailReader"/>
      <!-- ChaOS Custom Shortcuts -->
      <property name="&lt;Primary&gt;&lt;Alt&gt;t" type="string" value="exo-open --launch TerminalEmulator"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;f" type="string" value="exo-open --launch FileManager"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;w" type="string" value="exo-open --launch WebBrowser"/>
      <property name="&lt;Super&gt;t" type="string" value="exo-open --launch TerminalEmulator"/>
      <property name="&lt;Super&gt;f" type="string" value="exo-open --launch FileManager"/>
      <property name="&lt;Super&gt;w" type="string" value="exo-open --launch WebBrowser"/>
      <property name="&lt;Super&gt;r" type="string" value="xfce4-appfinder"/>
      <property name="&lt;Super&gt;space" type="string" value="xfce4-popup-applicationsmenu"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;h" type="string" value="xfce4-terminal -e htop"/>
      <property name="&lt;Super&gt;s" type="string" value="xfce4-screenshooter"/>
      <property name="Print" type="string" value="xfce4-screenshooter -f"/>
      <property name="&lt;Alt&gt;Print" type="string" value="xfce4-screenshooter -w"/>
      <property name="&lt;Shift&gt;Print" type="string" value="xfce4-screenshooter -r"/>
      <property name="&lt;Super&gt;l" type="string" value="xflock4"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;l" type="string" value="xflock4"/>
    </property>
  </property>
  <property name="xfwm4" type="empty">
    <property name="default" type="empty">
      <property name="&lt;Alt&gt;Insert" type="string" value="add_workspace_key"/>
      <property name="&lt;Alt&gt;Delete" type="string" value="del_workspace_key"/>
      <property name="&lt;Alt&gt;Tab" type="string" value="cycle_windows_key"/>
      <property name="&lt;Alt&gt;&lt;Shift&gt;Tab" type="string" value="cycle_reverse_windows_key"/>
      <property name="&lt;Alt&gt;F4" type="string" value="close_window_key"/>
      <property name="&lt;Alt&gt;F6" type="string" value="stick_window_key"/>
      <property name="&lt;Alt&gt;F7" type="string" value="move_window_key"/>
      <property name="&lt;Alt&gt;F8" type="string" value="resize_window_key"/>
      <property name="&lt;Alt&gt;F9" type="string" value="hide_window_key"/>
      <property name="&lt;Alt&gt;F10" type="string" value="maximize_window_key"/>
      <property name="&lt;Alt&gt;F11" type="string" value="fullscreen_key"/>
      <property name="&lt;Alt&gt;F12" type="string" value="above_key"/>
      <property name="&lt;Primary&gt;&lt;Shift&gt;&lt;Alt&gt;Left" type="string" value="move_window_left_key"/>
      <property name="&lt;Primary&gt;&lt;Shift&gt;&lt;Alt&gt;Right" type="string" value="move_window_right_key"/>
      <property name="&lt;Primary&gt;&lt;Shift&gt;&lt;Alt&gt;Up" type="string" value="move_window_up_key"/>
      <property name="&lt;Primary&gt;&lt;Shift&gt;&lt;Alt&gt;Down" type="string" value="move_window_down_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;End" type="string" value="move_window_next_workspace_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;Home" type="string" value="move_window_prev_workspace_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;KP_1" type="string" value="move_window_workspace_1_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;KP_2" type="string" value="move_window_workspace_2_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;KP_3" type="string" value="move_window_workspace_3_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;KP_4" type="string" value="move_window_workspace_4_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;KP_5" type="string" value="move_window_workspace_5_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;KP_6" type="string" value="move_window_workspace_6_key"/>
      <property name="&lt;Alt&gt;space" type="string" value="popup_menu_key"/>
      <property name="&lt;Shift&gt;&lt;Alt&gt;Page_Up" type="string" value="raise_window_key"/>
      <property name="&lt;Alt&gt;KP_1" type="string" value="workspace_1_key"/>
      <property name="&lt;Alt&gt;KP_2" type="string" value="workspace_2_key"/>
      <property name="&lt;Alt&gt;KP_3" type="string" value="workspace_3_key"/>
      <property name="&lt;Alt&gt;KP_4" type="string" value="workspace_4_key"/>
      <property name="&lt;Alt&gt;KP_5" type="string" value="workspace_5_key"/>
      <property name="&lt;Alt&gt;KP_6" type="string" value="workspace_6_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;Right" type="string" value="next_workspace_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;Left" type="string" value="prev_workspace_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;Up" type="string" value="up_workspace_key"/>
      <property name="&lt;Primary&gt;&lt;Alt&gt;Down" type="string" value="down_workspace_key"/>
      <property name="&lt;Alt&gt;&lt;Shift&gt;Page_Down" type="string" value="lower_window_key"/>
      <property name="&lt;Primary&gt;&lt;Shift&gt;&lt;Alt&gt;Left" type="string" value="move_window_left_workspace_key"/>
      <property name="&lt;Primary&gt;&lt;Shift&gt;&lt;Alt&gt;Right" type="string" value="move_window_right_workspace_key"/>
      <property name="&lt;Primary&gt;&lt;Shift&gt;&lt;Alt&gt;Up" type="string" value="move_window_up_workspace_key"/>
      <property name="&lt;Primary&gt;&lt;Shift&gt;&lt;Alt&gt;Down" type="string" value="move_window_down_workspace_key"/>
      <!-- ChaOS Custom Window Management -->
      <property name="&lt;Super&gt;Left" type="string" value="tile_left_key"/>
      <property name="&lt;Super&gt;Right" type="string" value="tile_right_key"/>
      <property name="&lt;Super&gt;Up" type="string" value="maximize_window_key"/>
      <property name="&lt;Super&gt;Down" type="string" value="hide_window_key"/>
      <property name="&lt;Super&gt;1" type="string" value="workspace_1_key"/>
      <property name="&lt;Super&gt;2" type="string" value="workspace_2_key"/>
      <property name="&lt;Super&gt;3" type="string" value="workspace_3_key"/>
      <property name="&lt;Super&gt;4" type="string" value="workspace_4_key"/>
      <property name="&lt;Super&gt;5" type="string" value="workspace_5_key"/>
      <property name="&lt;Super&gt;6" type="string" value="workspace_6_key"/>
      <property name="&lt;Super&gt;&lt;Shift&gt;1" type="string" value="move_window_workspace_1_key"/>
      <property name="&lt;Super&gt;&lt;Shift&gt;2" type="string" value="move_window_workspace_2_key"/>
      <property name="&lt;Super&gt;&lt;Shift&gt;3" type="string" value="move_window_workspace_3_key"/>
      <property name="&lt;Super&gt;&lt;Shift&gt;4" type="string" value="move_window_workspace_4_key"/>
      <property name="&lt;Super&gt;&lt;Shift&gt;5" type="string" value="move_window_workspace_5_key"/>
      <property name="&lt;Super&gt;&lt;Shift&gt;6" type="string" value="move_window_workspace_6_key"/>
      <property name="&lt;Super&gt;q" type="string" value="close_window_key"/>
      <property name="&lt;Super&gt;&lt;Shift&gt;q" type="string" value="close_window_key"/>
    </property>
  </property>
</channel>
EOF

# Configure XFCE settings
print_status "Configuring XFCE settings..."
cat > "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml" << 'EOF'
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

# Create ChaOS-branded desktop shortcuts
print_status "Creating ChaOS custom applications..."

# ChaOS About application
cat > "$USER_HOME/.local/share/applications/chaos-about.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=About ChaOS
Comment=Information about ChaOS Linux
Exec=zenity --info --title="About ChaOS Linux" --text="<b>Welcome to ChaOS Linux</b>\\n\\nVersion: 1.0 Genesis\\nBased on: Debian 12 Bookworm\\nDesktop: XFCE 4.18\\nTheme: Arc-Dark\\n\\n<b>Features:</b>\\n• Beautiful custom interface\\n• Gaming-optimized performance\\n• Developer-friendly tools\\n• Secure by default\\n\\n<b>ChaOS Project</b>\\nBuilding the future, one commit at a time." --width=400 --height=300
Icon=/usr/share/pixmaps/chaos/logo.png
Terminal=false
Categories=System;
EOF

# ChaOS System Monitor
cat > "$USER_HOME/.local/share/applications/chaos-system-monitor.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ChaOS System Monitor
Comment=Advanced system monitoring for ChaOS
Exec=sh -c 'if command -v htop >/dev/null; then xfce4-terminal --title="ChaOS System Monitor" -e htop; else xfce4-terminal --title="ChaOS System Monitor" -e top; fi'
Icon=utilities-system-monitor
Terminal=false
Categories=System;Monitor;
EOF

# ChaOS Welcome application
cat > "$USER_HOME/.local/share/applications/chaos-welcome.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Welcome to ChaOS
Comment=Getting started with ChaOS Linux
Exec=zenity --info --title="Welcome to ChaOS!" --text="<b>🎉 Welcome to ChaOS Linux!</b>\\n\\n<b>Quick Start Guide:</b>\\n\\n📁 <b>File Manager:</b> Click Thunar icon in dock\\n🌐 <b>Web Browser:</b> Firefox is pre-installed\\n💻 <b>Terminal:</b> Click terminal icon in dock\\n⚙️ <b>Settings:</b> Right-click desktop → Settings\\n🎮 <b>Gaming:</b> Steam and Lutris ready to install\\n\\n<b>Default Credentials:</b>\\nUsername: chaos\\nPassword: chaos\\n\\n<b>System Info:</b>\\nPress Ctrl+Alt+T for terminal\\nRun 'neofetch' to see system details\\n\\nEnjoy your ChaOS experience! 🚀" --width=500 --height=400
Icon=/usr/share/pixmaps/chaos/logo.png
Terminal=false
Categories=System;
EOF

# ChaOS Quick Setup for installed system
cat > "$USER_HOME/.local/share/applications/chaos-post-install.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ChaOS Post-Install Setup
Comment=Configure ChaOS after installation
Exec=zenity --question --title="ChaOS Post-Install Setup" --text="<b>Would you like to install additional software?</b>\\n\\nThis will install popular applications:\\n• Gaming: Steam, Lutris, Discord\\n• Development: VS Code, Git GUI\\n• Media: VLC, GIMP, Audacity\\n• Office: LibreOffice Suite\\n\\nThis requires internet connection." --width=400 && xfce4-terminal --title="ChaOS Post-Install" -e "bash -c 'echo Installing additional software...; sudo apt update && sudo apt install -y steam lutris discord code-oss vlc gimp audacity libreoffice; echo Installation complete! Press any key to close.; read'"
Icon=system-software-install
Terminal=false
Categories=System;Settings;
EOF

# Make all desktop entries executable
chmod +x "$USER_HOME/.local/share/applications/"*.desktop

# Create a desktop file for auto-starting welcome on first boot
mkdir -p "$USER_HOME/.config/autostart"
cat > "$USER_HOME/.config/autostart/chaos-welcome.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ChaOS Welcome
Comment=Show welcome message on first login
Exec=chaos-welcome.desktop
Icon=/usr/share/pixmaps/chaos/logo.png
Terminal=false
Categories=System;
X-GNOME-Autostart-enabled=true
EOF

# Restart XFCE panel to apply changes
print_status "Restarting XFCE panel..."
if pgrep -x "xfce4-panel" > /dev/null; then
    killall xfce4-panel
    nohup xfce4-panel > /dev/null 2>&1 &
fi

# Restart desktop to apply wallpaper
print_status "Restarting desktop..."
if pgrep -x "xfdesktop" > /dev/null; then
    killall xfdesktop
    nohup xfdesktop > /dev/null 2>&1 &
fi

print_success "ChaOS desktop customization completed!"
print_status "Changes applied:"
print_status "- ChaOS wallpaper set as background"
print_status "- Panel configured with ChaOS branding"
print_status "- Dark theme applied"
print_status "- ChaOS About shortcut created"
print_warning "Note: Some changes may require logging out and back in to take full effect"
