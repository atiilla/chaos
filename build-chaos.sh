#!/bin/bash

# ChaOS Linux Distribution Builder
# Main build script for creating ChaOS ISO

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
    echo "║                        ChaOS Builder                          ║"
    echo "║                    Custom Debian Distribution                 ║"
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

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="/tmp/chaos-build"
WORK_DIR="$BUILD_DIR/work"
CHROOT_DIR="$BUILD_DIR/chroot"
ISO_DIR="$BUILD_DIR/iso"
OUTPUT_DIR="$SCRIPT_DIR/output"

# ChaOS Information
DISTRO_NAME="ChaOS"
DISTRO_VERSION="1.0"
DISTRO_CODENAME="Genesis"
ISO_NAME="chaos-linux-${DISTRO_VERSION}-amd64.iso"

print_banner

print_status "Starting ChaOS Linux build process..."
print_status "Build directory: $BUILD_DIR"
print_status "Output directory: $OUTPUT_DIR"

# Clean previous build
if [ -d "$BUILD_DIR" ]; then
    print_step "Cleaning previous build..."
    rm -rf "$BUILD_DIR"
fi

# Create build directories
print_step "Creating build directories..."
mkdir -p "$BUILD_DIR" "$WORK_DIR" "$CHROOT_DIR" "$ISO_DIR" "$OUTPUT_DIR"

# Install required packages for building
print_step "Installing build dependencies..."
apt update
apt install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    dosfstools

# Bootstrap base Debian system
print_step "Bootstrapping base Debian system..."
debootstrap --arch=amd64 --variant=minbase bookworm "$CHROOT_DIR" http://deb.debian.org/debian/

# Configure chroot environment
print_step "Configuring chroot environment..."

# Mount necessary filesystems
mount --bind /dev "$CHROOT_DIR/dev"
mount --bind /dev/pts "$CHROOT_DIR/dev/pts"
mount --bind /proc "$CHROOT_DIR/proc"
mount --bind /sys "$CHROOT_DIR/sys"

# Copy DNS configuration
cp /etc/resolv.conf "$CHROOT_DIR/etc/resolv.conf"

# Create ChaOS-specific configuration
cat > "$CHROOT_DIR/etc/os-release" << EOF
PRETTY_NAME="$DISTRO_NAME Linux $DISTRO_VERSION ($DISTRO_CODENAME)"
NAME="$DISTRO_NAME Linux"
VERSION_ID="$DISTRO_VERSION"
VERSION="$DISTRO_VERSION ($DISTRO_CODENAME)"
VERSION_CODENAME="$DISTRO_CODENAME"
ID=chaos
ID_LIKE=debian
HOME_URL="https://chaos-linux.org/"
SUPPORT_URL="https://chaos-linux.org/support"
BUG_REPORT_URL="https://chaos-linux.org/bugs"
EOF

# Create chroot configuration script
cat > "$CHROOT_DIR/tmp/setup-chaos.sh" << 'CHROOT_SCRIPT'
#!/bin/bash

set -e

# Colors for output in chroot
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[CHROOT INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[CHROOT SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[CHROOT WARNING]${NC} $1"
}

export DEBIAN_FRONTEND=noninteractive

print_status "Configuring package sources..."
cat > /etc/apt/sources.list << EOF
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
EOF

print_status "Updating package list..."
apt update

print_status "Installing essential packages..."
apt install -y \
    linux-image-amd64 \
    firmware-linux \
    firmware-linux-nonfree \
    intel-microcode \
    amd64-microcode \
    initramfs-tools \
    systemd \
    systemd-sysv \
    dbus \
    sudo \
    nano \
    vim \
    curl \
    wget \
    git \
    htop \
    neofetch \
    tree \
    unzip \
    zip \
    rsync \
    openssh-client \
    openssh-server \
    ca-certificates \
    apt-transport-https \
    build-essential \
    python3 \
    python3-pip \
    net-tools \
    tcpdump \
    nmap \
    wireshark-common

print_status "Installing network and hardware support..."
apt install -y \
    network-manager \
    wireless-tools \
    wpasupplicant \
    firmware-iwlwifi \
    firmware-realtek \
    firmware-atheros \
    alsa-utils

print_status "Installing live system packages..."
apt install -y \
    live-boot \
    live-config \
    live-config-systemd \
    live-tools \
    discover \
    laptop-detect \
    user-setup

print_status "Installing bootloader..."
apt install -y \
    grub-pc-bin \
    grub-efi-amd64 \
    grub-efi-amd64-signed

print_status "Installing desktop themes..."
apt install -y \
    arc-theme \
    papirus-icon-theme \
    fonts-noto

print_status "Installing essential security and network tools (reduced set for size)..."
apt install -y \
    nmap \
    netcat-traditional \
    dnsutils \
    whois \
    traceroute \
    curl \
    wget \
    aircrack-ng \
    john \
    macchanger

print_status "Installing virtualization support..."
apt install -y \
    open-vm-tools \
    open-vm-tools-desktop \
    spice-vdagent \
    qemu-guest-agent

# Install VirtualBox Guest Additions if available
print_status "Attempting to install VirtualBox Guest Additions..."
if apt-cache show virtualbox-guest-utils >/dev/null 2>&1; then
    apt install -y virtualbox-guest-utils
    print_status "VirtualBox Guest Additions installed successfully"
else
    print_warning "VirtualBox Guest Additions not available in repositories"
fi

print_status "Configuring locales..."
apt install -y locales
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8

print_status "Configuring timezone..."
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

print_status "Creating live user..."
useradd -m -s /bin/bash chaos
echo "chaos:chaos" | chpasswd
usermod -aG sudo chaos

# Configure Arc-Dark theme for live user and set as system default
print_status "Configuring Arc-Dark theme for live user..."
mkdir -p /home/chaos/.config/xfce4/xfconf/xfce-perchannel-xml
mkdir -p /home/chaos/.config/gtk-3.0
mkdir -p /home/chaos/.config/gtk-4.0

# Set GTK theme globally
cat > /home/chaos/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Noto Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

# Also set for GTK4
cp /home/chaos/.config/gtk-3.0/settings.ini /home/chaos/.config/gtk-4.0/

# Set as default for all new users
mkdir -p /etc/skel/.config/gtk-3.0
mkdir -p /etc/skel/.config/gtk-4.0
cp /home/chaos/.config/gtk-3.0/settings.ini /etc/skel/.config/gtk-3.0/
cp /home/chaos/.config/gtk-4.0/settings.ini /etc/skel/.config/gtk-4.0/

# Set system-wide GTK settings
mkdir -p /etc/gtk-3.0
cat > /etc/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Noto Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
EOF

# Create XFCE configuration for live user to ensure wallpaper is set
cat > /home/chaos/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml << EOF
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

# Set ownership
chown -R chaos:chaos /home/chaos/.config

# Configure sudo for live user
echo "chaos ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/chaos

print_status "Configuring hostname..."
echo "chaos-live" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1   localhost
127.0.1.1   chaos-live

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

print_status "Enabling services..."
systemctl enable NetworkManager
systemctl enable ssh

# Only enable bluetooth if it exists
if systemctl list-unit-files | grep -q bluetooth.service; then
    systemctl enable bluetooth
    print_status "Bluetooth service enabled"
else
    print_warning "Bluetooth service not available (this is normal for minimal installs)"
fi

# Enable virtualization services
print_status "Enabling virtualization services..."
systemctl enable open-vm-tools 2>/dev/null || print_warning "open-vm-tools service not available"
systemctl enable spice-vdagent 2>/dev/null || print_warning "spice-vdagent service not available"
systemctl enable qemu-guest-agent 2>/dev/null || print_warning "qemu-guest-agent service not available"

# Try to enable VirtualBox services if installed
if systemctl list-unit-files | grep -q virtualbox; then
    systemctl enable virtualbox-guest-utils 2>/dev/null || true
    print_status "VirtualBox services enabled"
fi

print_status "Aggressive cleanup for lightweight OS..."
apt autoremove -y --purge
apt autoclean
apt clean

# Remove unnecessary packages to save space
print_status "Removing unnecessary packages..."
apt remove -y --purge \
    manpages \
    manpages-dev \
    doc-base \
    info \
    install-info 2>/dev/null || true

# Clean up package cache and temporary files
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf /var/log/*.log
rm -rf /var/log/*/*.log 2>/dev/null || true

# Remove documentation to save space
rm -rf /usr/share/doc/*
rm -rf /usr/share/man/*
rm -rf /usr/share/info/*

# Remove unnecessary locales (keep only en_US)
find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name 'en_US*' -type d -exec rm -rf {} + 2>/dev/null || true

# Remove cache files
find /var/cache -type f -delete 2>/dev/null || true

# Clear systemd journal
journalctl --vacuum-size=1M 2>/dev/null || true

print_status "Lightweight cleanup completed"

print_success "ChaOS chroot environment configured successfully!"
CHROOT_SCRIPT

chmod +x "$CHROOT_DIR/tmp/setup-chaos.sh"

# Execute chroot configuration
print_step "Configuring ChaOS system in chroot..."
chroot "$CHROOT_DIR" /tmp/setup-chaos.sh

# Copy ChaOS customizations to chroot
print_step "Installing ChaOS customizations..."

# Copy branding assets first and install them properly
if [ -d "$SCRIPT_DIR/branding_assets" ]; then
    cp -r "$SCRIPT_DIR/branding_assets" "$CHROOT_DIR/tmp/"
    print_status "Copied branding assets to chroot"
    
    # Install wallpapers to proper system directories
    chroot "$CHROOT_DIR" /bin/bash -c "
        mkdir -p /usr/share/backgrounds/chaos
        mkdir -p /usr/share/pixmaps/chaos
        mkdir -p /usr/share/images/desktop-base
        if [ -f /tmp/branding_assets/wallpaper.png ]; then
            cp /tmp/branding_assets/wallpaper.png /usr/share/backgrounds/chaos/
            cp /tmp/branding_assets/wallpaper.png /usr/share/pixmaps/chaos/
            cp /tmp/branding_assets/wallpaper.png /usr/share/images/desktop-base/
            ln -sf /usr/share/images/desktop-base/wallpaper.png /usr/share/images/desktop-base/default
        fi
        if [ -f /tmp/branding_assets/logo.png ]; then
            cp /tmp/branding_assets/logo.png /usr/share/pixmaps/chaos/
        fi
        if [ -f /tmp/branding_assets/chaos-icon.ico ]; then
            cp /tmp/branding_assets/chaos-icon.ico /usr/share/pixmaps/chaos/
        fi
        # Set as default wallpaper for all users
        mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
        cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << 'WALLPAPER_EOF'
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<channel name=\"xfce4-desktop\" version=\"1.0\">
  <property name=\"backdrop\" type=\"empty\">
    <property name=\"screen0\" type=\"empty\">
      <property name=\"monitor0\" type=\"empty\">
        <property name=\"workspace0\" type=\"empty\">
          <property name=\"color-style\" type=\"int\" value=\"0\"/>
          <property name=\"image-style\" type=\"int\" value=\"5\"/>
          <property name=\"last-image\" type=\"string\" value=\"/usr/share/images/desktop-base/wallpaper.png\"/>
        </property>
        <property name=\"workspace1\" type=\"empty\">
          <property name=\"color-style\" type=\"int\" value=\"0\"/>
          <property name=\"image-style\" type=\"int\" value=\"5\"/>
          <property name=\"last-image\" type=\"string\" value=\"/usr/share/images/desktop-base/wallpaper.png\"/>
        </property>
        <property name=\"workspace2\" type=\"empty\">
          <property name=\"color-style\" type=\"int\" value=\"0\"/>
          <property name=\"image-style\" type=\"int\" value=\"5\"/>
          <property name=\"last-image\" type=\"string\" value=\"/usr/share/images/desktop-base/wallpaper.png\"/>
        </property>
        <property name=\"workspace3\" type=\"empty\">
          <property name=\"color-style\" type=\"int\" value=\"0\"/>
          <property name=\"image-style\" type=\"int\" value=\"5\"/>
          <property name=\"last-image\" type=\"string\" value=\"/usr/share/images/desktop-base/wallpaper.png\"/>
        </property>
      </property>
    </property>
  </property>
</channel>
WALLPAPER_EOF
        # Also copy to live user
        mkdir -p /home/chaos/.config/xfce4/xfconf/xfce-perchannel-xml
        cp /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /home/chaos/.config/xfce4/xfconf/xfce-perchannel-xml/
        
        # Set up system default XFCE configuration as well
        mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
        cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml << 'THEME_EOF'
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<channel name=\"xsettings\" version=\"1.0\">
  <property name=\"Net\" type=\"empty\">
    <property name=\"ThemeName\" type=\"string\" value=\"Arc-Dark\"/>
    <property name=\"IconThemeName\" type=\"string\" value=\"Papirus-Dark\"/>
    <property name=\"DoubleClickTime\" type=\"uint\" value=\"400\"/>
    <property name=\"DoubleClickDistance\" type=\"uint\" value=\"5\"/>
    <property name=\"DndDragThreshold\" type=\"uint\" value=\"8\"/>
    <property name=\"CursorBlink\" type=\"bool\" value=\"true\"/>
    <property name=\"CursorBlinkTime\" type=\"uint\" value=\"1200\"/>
    <property name=\"SoundThemeName\" type=\"string\" value=\"default\"/>
    <property name=\"EnableEventSounds\" type=\"bool\" value=\"false\"/>
    <property name=\"EnableInputFeedbackSounds\" type=\"bool\" value=\"false\"/>
  </property>
  <property name=\"Xft\" type=\"empty\">
    <property name=\"DPI\" type=\"int\" value=\"96\"/>
    <property name=\"Antialias\" type=\"int\" value=\"1\"/>
    <property name=\"Hinting\" type=\"int\" value=\"1\"/>
    <property name=\"HintStyle\" type=\"string\" value=\"hintslight\"/>
    <property name=\"RGBA\" type=\"string\" value=\"rgb\"/>
  </property>
  <property name=\"Gtk\" type=\"empty\">
    <property name=\"CanChangeAccels\" type=\"bool\" value=\"false\"/>
    <property name=\"ColorPalette\" type=\"string\" value=\"black:white:gray50:red:purple:blue:light blue:green:yellow:orange:lavender:brown:goldenrod4:dodger blue:pink:light green:gray10:gray30:gray75:gray90\"/>
    <property name=\"FontName\" type=\"string\" value=\"Noto Sans 10\"/>
    <property name=\"IconSizes\" type=\"string\" value=\"\"/>
    <property name=\"KeyThemeName\" type=\"string\" value=\"\"/>
    <property name=\"ToolbarStyle\" type=\"string\" value=\"icons\"/>
    <property name=\"ToolbarIconSize\" type=\"uint\" value=\"3\"/>
    <property name=\"MenuImages\" type=\"bool\" value=\"true\"/>
    <property name=\"ButtonImages\" type=\"bool\" value=\"true\"/>
    <property name=\"MenuBarAccel\" type=\"string\" value=\"F10\"/>
    <property name=\"CursorThemeName\" type=\"string\" value=\"\"/>
    <property name=\"CursorThemeSize\" type=\"uint\" value=\"0\"/>
    <property name=\"DecorationLayout\" type=\"string\" value=\"menu:minimize,maximize,close\"/>
  </property>
</channel>
THEME_EOF
        
        # Copy theme settings to live user too
        cp /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml /home/chaos/.config/xfce4/xfconf/xfce-perchannel-xml/
        
        # Set Application Menu icon to ChaOS logo
        mkdir -p /home/chaos/.config/xfce4/xfconf/xfce-perchannel-xml
        cat > /home/chaos/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml << 'PANEL_EOF'
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<channel name=\"xfce4-panel\" version=\"1.0\">
  <property name=\"configver\" type=\"int\" value=\"2\"/>
  <property name=\"panels\" type=\"array\">
    <value type=\"int\" value=\"1\"/>
    <property name=\"panel-1\" type=\"empty\">
      <property name=\"position\" type=\"string\" value=\"p=8;x=0;y=0\"/>
      <property name=\"length\" type=\"uint\" value=\"100\"/>
      <property name=\"position-locked\" type=\"bool\" value=\"true\"/>
      <property name=\"size\" type=\"uint\" value=\"30\"/>
      <property name=\"plugin-ids\" type=\"array\">
        <value type=\"int\" value=\"1\"/>
        <value type=\"int\" value=\"2\"/>
        <value type=\"int\" value=\"3\"/>
        <value type=\"int\" value=\"4\"/>
        <value type=\"int\" value=\"5\"/>
        <value type=\"int\" value=\"6\"/>
      </property>
    </property>
  </property>
  <property name=\"plugins\" type=\"empty\">
    <property name=\"plugin-1\" type=\"string\" value=\"applicationsmenu\">
      <property name=\"button-icon\" type=\"string\" value=\"/usr/share/pixmaps/chaos/chaos-icon.ico\"/>
      <property name=\"button-title\" type=\"string\" value=\"Applications\"/>
      <property name=\"show-button-title\" type=\"bool\" value=\"false\"/>
    </property>
    <property name=\"plugin-2\" type=\"string\" value=\"separator\">
      <property name=\"expand\" type=\"bool\" value=\"true\"/>
      <property name=\"style\" type=\"uint\" value=\"0\"/>
    </property>
    <property name=\"plugin-3\" type=\"string\" value=\"tasklist\"/>
    <property name=\"plugin-4\" type=\"string\" value=\"separator\">
      <property name=\"style\" type=\"uint\" value=\"0\"/>
    </property>
    <property name=\"plugin-5\" type=\"string\" value=\"systray\"/>
    <property name=\"plugin-6\" type=\"string\" value=\"clock\"/>
  </property>
</channel>
PANEL_EOF
        
        chown -R chaos:chaos /home/chaos/.config
    "
fi

if [ -d "$SCRIPT_DIR/xfce-config" ]; then
    cp -r "$SCRIPT_DIR/xfce-config" "$CHROOT_DIR/tmp/"
    chroot "$CHROOT_DIR" /tmp/xfce-config/install-xfce.sh
    # Apply ChaOS custom panel and menu configurations
    chroot "$CHROOT_DIR" chmod +x /tmp/xfce-config/chaos-panel-config.sh
    chroot "$CHROOT_DIR" chmod +x /tmp/xfce-config/chaos-menulibre-setup.sh
    # Run panel config as user
    chroot "$CHROOT_DIR" su - chaos -c "/tmp/xfce-config/chaos-panel-config.sh"
    # Install ChaOS Tools menu system-wide with sample applications
    chroot "$CHROOT_DIR" /tmp/xfce-config/chaos-menulibre-setup.sh
fi

if [ -d "$SCRIPT_DIR/grub2-themes/ChaOS" ]; then
    cp -r "$SCRIPT_DIR/grub2-themes/ChaOS" "$CHROOT_DIR/tmp/"
    # Copy entire grub2-themes structure so relative paths work
    cp -r "$SCRIPT_DIR/grub2-themes" "$CHROOT_DIR/tmp/"
    chroot "$CHROOT_DIR" /tmp/ChaOS/install.sh
fi

# Clean up chroot
print_step "Cleaning up chroot environment..."
rm -f "$CHROOT_DIR/etc/resolv.conf"
rm -rf "$CHROOT_DIR/tmp/setup-chaos.sh"
rm -rf "$CHROOT_DIR/tmp/xfce-config"
rm -rf "$CHROOT_DIR/tmp/ChaOS"
rm -rf "$CHROOT_DIR/tmp/grub2-themes"
rm -rf "$CHROOT_DIR/tmp/branding_assets"

# Unmount filesystems
print_step "Unmounting chroot filesystems..."
# Force unmount in reverse order
umount -l "$CHROOT_DIR/sys" 2>/dev/null || true
umount -l "$CHROOT_DIR/proc" 2>/dev/null || true
umount -l "$CHROOT_DIR/dev/pts" 2>/dev/null || true
umount -l "$CHROOT_DIR/dev" 2>/dev/null || true

# Wait a moment for unmounts to complete
sleep 2

# Check if any mounts are still active and force unmount them
for mount_point in "$CHROOT_DIR/sys" "$CHROOT_DIR/proc" "$CHROOT_DIR/dev/pts" "$CHROOT_DIR/dev"; do
    if mountpoint -q "$mount_point" 2>/dev/null; then
        print_warning "Force unmounting $mount_point"
        umount -f "$mount_point" 2>/dev/null || true
    fi
done

# Create squashfs filesystem with better compression
print_step "Creating compressed filesystem..."
mkdir -p "$ISO_DIR/live"

# Clean up more files to reduce size
print_status "Additional cleanup to reduce ISO size..."
chroot "$CHROOT_DIR" /bin/bash -c "
    # Remove documentation and man pages
    rm -rf /usr/share/doc/* 2>/dev/null || true
    rm -rf /usr/share/man/* 2>/dev/null || true
    rm -rf /usr/share/info/* 2>/dev/null || true
    rm -rf /usr/share/locale/* 2>/dev/null || true
    rm -rf /var/log/* 2>/dev/null || true
    rm -rf /var/cache/apt/* 2>/dev/null || true
    rm -rf /var/lib/apt/lists/* 2>/dev/null || true
    rm -rf /tmp/* 2>/dev/null || true
    rm -rf /var/tmp/* 2>/dev/null || true
    # Remove source code and headers if not needed
    rm -rf /usr/src/* 2>/dev/null || true
    # Clean package cache
    apt-get clean 2>/dev/null || true
    # Remove unnecessary kernel modules
    find /lib/modules -name '*.ko' | grep -E '(wireless|bluetooth|sound)' | head -50 | xargs rm -f 2>/dev/null || true
"

# Use maximum compression for squashfs
mksquashfs "$CHROOT_DIR" "$ISO_DIR/live/filesystem.squashfs" \
    -e boot -comp xz -Xbcj x86 -b 256K -Xdict-size 100% -always-use-fragments -duplicate-check

# Calculate filesystem size
printf $(du -sx --block-size=1 "$CHROOT_DIR" | cut -f1) > "$ISO_DIR/live/filesystem.size"

# Copy kernel and initrd
print_step "Copying kernel and initrd..."
cp "$CHROOT_DIR/boot"/vmlinuz-* "$ISO_DIR/live/vmlinuz"
cp "$CHROOT_DIR/boot"/initrd.img-* "$ISO_DIR/live/initrd"

# Create isolinux configuration
print_step "Creating bootloader configuration..."
mkdir -p "$ISO_DIR/isolinux"

cat > "$ISO_DIR/isolinux/isolinux.cfg" << EOF
UI vesamenu.c32

MENU TITLE ChaOS Linux Live Boot Menu
MENU BACKGROUND grub_background.png

MENU COLOR border       30;44   #40ffffff #a0000000 std
MENU COLOR title        1;36;44 #9033ccff #a0000000 std
MENU COLOR sel          7;37;40 #e0ffffff #20ffffff all
MENU COLOR unsel        37;44   #50ffffff #a0000000 std
MENU COLOR help         37;40   #c0ffffff #a0000000 std
MENU COLOR timeout_msg  37;40   #80ffffff #00000000 std
MENU COLOR timeout      1;37;40 #c0ffffff #00000000 std
MENU COLOR msg07        37;40   #90ffffff #a0000000 std
MENU COLOR tabmsg       31;40   #30ffffff #00000000 std

DEFAULT live
TIMEOUT 30

LABEL live
    MENU LABEL ^Live (amd64)
    MENU DEFAULT
    KERNEL /live/vmlinuz
    APPEND initrd=/live/initrd boot=live components hostname=chaos-live username=chaos user-fullname="ChaOS Live User" locales=en_US.UTF-8 timezone=UTC quiet splash

LABEL install
    MENU LABEL ^Install ChaOS
    KERNEL /live/vmlinuz
    APPEND initrd=/live/initrd boot=live components hostname=chaos-live username=chaos user-fullname="ChaOS Live User" locales=en_US.UTF-8 timezone=UTC quiet splash debian-installer/live-installer

LABEL check
    MENU LABEL ^Check disc for defects
    KERNEL /live/vmlinuz
    APPEND initrd=/live/initrd boot=live components hostname=chaos-live username=chaos user-fullname="ChaOS Live User" locales=en_US.UTF-8 timezone=UTC quiet splash integrity-check

LABEL memtest
    MENU LABEL ^Memory test
    KERNEL memtest86+.bin

LABEL hdt
    MENU LABEL ^Hardware Detection Tool
    COM32 hdt.c32
EOF

# Copy isolinux files
cp /usr/lib/ISOLINUX/isolinux.bin "$ISO_DIR/isolinux/"
cp /usr/lib/syslinux/modules/bios/*.c32 "$ISO_DIR/isolinux/"

# Copy GRUB background for isolinux if available
if [ -f "$SCRIPT_DIR/branding_assets/grub_background.png" ]; then
    cp "$SCRIPT_DIR/branding_assets/grub_background.png" "$ISO_DIR/isolinux/"
    print_status "Copied GRUB background for isolinux"
elif [ -f "$SCRIPT_DIR/branding_assets/splash.png" ]; then
    cp "$SCRIPT_DIR/branding_assets/splash.png" "$ISO_DIR/isolinux/grub_background.png"
    print_status "Using splash.png as GRUB background for isolinux"
fi

# Create GRUB EFI configuration
print_step "Creating GRUB EFI configuration..."
mkdir -p "$ISO_DIR/boot/grub"

# Copy GRUB background image and create theme
if [ -f "$SCRIPT_DIR/branding_assets/grub_background.png" ]; then
    cp "$SCRIPT_DIR/branding_assets/grub_background.png" "$ISO_DIR/boot/grub/"
    print_status "Copied GRUB background image"
    
    # Create GRUB theme directory and files
    mkdir -p "$ISO_DIR/boot/grub/themes/chaos"
    cp "$SCRIPT_DIR/branding_assets/grub_background.png" "$ISO_DIR/boot/grub/themes/chaos/"
    
    # Create theme.txt for proper background handling
    cat > "$ISO_DIR/boot/grub/themes/chaos/theme.txt" << 'THEME_EOF'
# ChaOS GRUB Theme
# General settings
title-text: ""
desktop-image: "grub_background.png"
desktop-image-scale-method: stretch
desktop-image-h-align: center
desktop-image-v-align: center

# Menu settings
+ boot_menu {
    left = 10%
    top = 20%
    width = 80%
    height = 60%
    item_font = "DejaVu Sans Regular 16"
    item_color = "#ffffff"
    selected_item_color = "#000000"
    selected_item_pixmap_style = "selected_*.png"
    item_height = 32
    item_padding = 8
    item_spacing = 4
    icon_width = 24
    icon_height = 24
    scrollbar = true
    scrollbar_width = 16
    scrollbar_thumb = "slider_*.png"
}

# Progress bar
+ progress_bar {
    id = "__timeout__"
    left = 10%
    top = 85%
    width = 80%
    height = 16
    font = "DejaVu Sans Regular 12"
    text_color = "#ffffff"
    fg_color = "#ff0000"
    bg_color = "#000000"
    border_color = "#ffffff"
    text = "@TIMEOUT_NOTIFICATION_LONG@"
}
THEME_EOF
    
    print_status "Created GRUB theme configuration"
fi

cat > "$ISO_DIR/boot/grub/grub.cfg" << 'EOF'
# Load necessary modules
insmod all_video
insmod gfxterm
insmod png
insmod font

# Set graphics mode
if loadfont /boot/grub/font.pf2 ; then
    set gfxmode=auto
    insmod efi_gop
    insmod efi_uga
    insmod gfxterm
    terminal_output gfxterm
fi

# Load theme if available
if [ -f /boot/grub/themes/chaos/theme.txt ]; then
    set theme=/boot/grub/themes/chaos/theme.txt
    export theme
else
    # Fallback: Set background image directly with stretch
    if background_image /boot/grub/grub_background.png; then
        set color_normal=white/black
        set color_highlight=black/light-gray
    else
        set menu_color_normal=white/black
        set menu_color_highlight=black/light-gray
    fi
fi

# Menu timeout
set timeout=10
set default=0

menuentry "ChaOS Linux Live (amd64)" {
    linux /live/vmlinuz boot=live components hostname=chaos-live username=chaos user-fullname="ChaOS Live User" locales=en_US.UTF-8 timezone=UTC quiet splash
    initrd /live/initrd
}

menuentry "Install ChaOS Linux" {
    linux /live/vmlinuz boot=live components hostname=chaos-live username=chaos user-fullname="ChaOS Live User" locales=en_US.UTF-8 timezone=UTC quiet splash debian-installer/live-installer
    initrd /live/initrd
}

menuentry "Check disc for defects" {
    linux /live/vmlinuz boot=live components hostname=chaos-live username=chaos user-fullname="ChaOS Live User" locales=en_US.UTF-8 timezone=UTC quiet splash integrity-check
    initrd /live/initrd
}

menuentry "Memory Test (memtest86+)" {
    linux16 /boot/memtest86+.bin
}
EOF

# Create EFI boot structure
mkdir -p "$ISO_DIR/EFI/BOOT"
grub-mkstandalone \
    --format=x86_64-efi \
    --output="$ISO_DIR/EFI/BOOT/bootx64.efi" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=$ISO_DIR/boot/grub/grub.cfg"

# Create the ISO with size optimization
print_step "Creating ISO image..."
print_status "Filesystem size: $(du -sh "$ISO_DIR" | cut -f1)"
print_status "SquashFS size: $(du -sh "$ISO_DIR/live/filesystem.squashfs" | cut -f1)"

# Try to create ISO with optimizations
create_iso_with_fallback() {
    local output_file="$1"
    local iso_dir="$2"
    
    print_status "Attempting to create ISO image..."
    
    # First attempt: Standard ISO creation with size optimization
    if xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "CHAOS_LINUX" \
        -appid "ChaOS Linux Live" \
        -publisher "ChaOS Project" \
        -preparer "ChaOS Builder" \
        -eltorito-boot isolinux/isolinux.bin \
        -eltorito-catalog isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
        -eltorito-alt-boot \
        -e EFI/BOOT/bootx64.efi \
        -no-emul-boot \
        -isohybrid-gpt-basdat \
        -joliet on \
        -rational-rock \
        -output "$output_file" \
        "$iso_dir"; then
        
        print_success "ISO created successfully with standard method"
        return 0
    fi
    
    print_warning "Standard ISO creation failed, trying alternative method..."
    
    # Second attempt: Without hybrid MBR
    if xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "CHAOS_LINUX" \
        -appid "ChaOS Linux Live" \
        -publisher "ChaOS Project" \
        -preparer "ChaOS Builder" \
        -eltorito-boot isolinux/isolinux.bin \
        -eltorito-catalog isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -eltorito-alt-boot \
        -e EFI/BOOT/bootx64.efi \
        -no-emul-boot \
        -output "$output_file" \
        "$iso_dir"; then
        
        print_success "ISO created successfully with alternative method"
        return 0
    fi
    
    print_error "ISO creation failed with all methods"
    return 1
}

# Create the ISO using the fallback function
create_iso_with_fallback "$OUTPUT_DIR/$ISO_NAME" "$ISO_DIR"

# Calculate checksums
print_step "Calculating checksums..."
cd "$OUTPUT_DIR"
md5sum "$ISO_NAME" > "${ISO_NAME}.md5"
sha256sum "$ISO_NAME" > "${ISO_NAME}.sha256"

# Clean up
print_step "Cleaning up build files..."

# Function to safely clean up chroot
cleanup_chroot() {
    local chroot_path="$1"
    
    if [ ! -d "$chroot_path" ]; then
        return 0
    fi
    
    print_status "Safely cleaning up chroot at $chroot_path"
    
    # Unmount any remaining filesystems
    for mount_point in "$chroot_path/sys" "$chroot_path/proc" "$chroot_path/dev/pts" "$chroot_path/dev"; do
        if mountpoint -q "$mount_point" 2>/dev/null; then
            print_warning "Unmounting $mount_point"
            umount -l "$mount_point" 2>/dev/null || umount -f "$mount_point" 2>/dev/null || true
        fi
    done
    
    # Wait for unmounts to complete
    sleep 3
    
    # Remove any problematic proc files first
    if [ -d "$chroot_path/proc" ]; then
        find "$chroot_path/proc" -type f -exec rm -f {} + 2>/dev/null || true
        find "$chroot_path/proc" -type l -exec rm -f {} + 2>/dev/null || true
    fi
    
    # Remove the chroot directory
    rm -rf "$chroot_path" 2>/dev/null || {
        print_warning "Standard removal failed, trying with elevated permissions"
        find "$chroot_path" -type d -exec chmod 755 {} + 2>/dev/null || true
        find "$chroot_path" -type f -exec chmod 644 {} + 2>/dev/null || true
        rm -rf "$chroot_path" 2>/dev/null || true
    }
}

# Use the cleanup function
cleanup_chroot "$BUILD_DIR"

print_success "ChaOS ISO created successfully!"
print_status "ISO location: $OUTPUT_DIR/$ISO_NAME"
print_status "Size: $(du -h "$OUTPUT_DIR/$ISO_NAME" | cut -f1)"
print_status "MD5: $(cat "$OUTPUT_DIR/${ISO_NAME}.md5" | cut -d' ' -f1)"
print_status "SHA256: $(cat "$OUTPUT_DIR/${ISO_NAME}.sha256" | cut -d' ' -f1)"

echo
echo -e "${GREEN}Build completed! You can now:"
echo -e "1. Test the ISO in a virtual machine"
echo -e "2. Write it to a USB drive using dd or similar tool"
echo -e "3. Boot from the ISO to test ChaOS Linux${NC}"
