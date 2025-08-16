#!/bin/bash

# ChaOS Application Menu Configuration Script
# Customizes XFCE application menu according to ChaOS specifications

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

print_status "Configuring ChaOS custom application menu..."

# Create directories for custom menu configuration
mkdir -p "$USER_HOME/.config/menus"
mkdir -p "$USER_HOME/.local/share/desktop-directories"
mkdir -p "$USER_HOME/.local/share/applications"
# Also create system-wide directories
mkdir -p /etc/xdg/menus
mkdir -p /usr/share/desktop-directories

# Create ChaOS Tools directory entry
print_status "Creating ChaOS Tools submenu..."
cat > "$USER_HOME/.local/share/desktop-directories/chaos-tools.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=ChaOS Tools
Name[en_US]=ChaOS Tools
Comment=Security and penetration testing tools
Comment[en_US]=Security and penetration testing tools
Icon=applications-security
EOF

# Also copy to system-wide location
cp "$USER_HOME/.local/share/desktop-directories/chaos-tools.directory" "/usr/share/desktop-directories/"

# Create Red Team Tools categories
print_status "Creating Red Team Tools categories..."

# Information Gathering category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-info-gathering.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Information Gathering
Name[en_US]=Information Gathering
Comment=Tools for reconnaissance and information gathering
Comment[en_US]=Tools for reconnaissance and information gathering
Icon=applications-internet
EOF

# Vulnerability Analysis category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-vulnerability-analysis.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Vulnerability Analysis
Name[en_US]=Vulnerability Analysis
Comment=Tools for vulnerability scanning and analysis
Comment[en_US]=Tools for vulnerability scanning and analysis
Icon=applications-debugging
EOF

# Web Application Analysis category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-web-analysis.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Web Application Analysis
Name[en_US]=Web Application Analysis
Comment=Tools for web application security testing
Comment[en_US]=Tools for web application security testing
Icon=applications-internet
EOF

# Database Assessment category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-database-assessment.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Database Assessment
Name[en_US]=Database Assessment
Comment=Tools for database security assessment
Comment[en_US]=Tools for database security assessment
Icon=applications-office
EOF

# Password Attacks category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-password-attacks.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Password Attacks
Name[en_US]=Password Attacks
Comment=Tools for password cracking and attacks
Comment[en_US]=Tools for password cracking and attacks
Icon=dialog-password
EOF

# Wireless Attacks category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-wireless-attacks.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Wireless Attacks
Name[en_US]=Wireless Attacks
Comment=Tools for wireless network security testing
Comment[en_US]=Tools for wireless network security testing
Icon=network-wireless
EOF

# Exploitation Tools category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-exploitation.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Exploitation Tools
Name[en_US]=Exploitation Tools
Comment=Tools for exploitation and payload generation
Comment[en_US]=Tools for exploitation and payload generation
Icon=applications-system
EOF

# Sniffing & Spoofing category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-sniffing-spoofing.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Sniffing & Spoofing
Name[en_US]=Sniffing & Spoofing
Comment=Tools for network sniffing and spoofing
Comment[en_US]=Tools for network sniffing and spoofing
Icon=network-wired
EOF

# Post Exploitation category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-post-exploitation.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Post Exploitation
Name[en_US]=Post Exploitation
Comment=Tools for post-exploitation activities
Comment[en_US]=Tools for post-exploitation activities
Icon=applications-system
EOF

# Forensics category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-forensics.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Forensics
Name[en_US]=Forensics
Comment=Tools for digital forensics and analysis
Comment[en_US]=Tools for digital forensics and analysis
Icon=applications-science
EOF

# Reverse Engineering category
cat > "$USER_HOME/.local/share/desktop-directories/chaos-reverse-engineering.directory" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=Reverse Engineering
Name[en_US]=Reverse Engineering
Comment=Tools for reverse engineering and binary analysis
Comment[en_US]=Tools for reverse engineering and binary analysis
Icon=applications-development
EOF

# Create custom applications menu
print_status "Creating custom applications menu without mail client..."
cat > "$USER_HOME/.config/menus/applications.menu" << 'EOF'
<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
  "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">

<Menu>
  <Name>Applications</Name>
  <Directory>applications.directory</Directory>

  <!-- Read standard .directory and .desktop file locations -->
  <DefaultAppDirs/>
  <DefaultDirectoryDirs/>

  <!-- Read in overrides and child menus from applications-merged/ -->
  <DefaultMergeDirs/>

  <!-- Accessories submenu -->
  <Menu>
    <Name>Accessories</Name>
    <Directory>xfce-accessories.directory</Directory>
    <Include>
      <And>
        <Category>Utility</Category>
        <Not><Category>X-Xfce-Toplevel</Category></Not>
        <Not><Category>System</Category></Not>
      </And>
    </Include>
  </Menu>

  <!-- Development -->
  <Menu>
    <Name>Development</Name>
    <Directory>xfce-development.directory</Directory>
    <Include>
      <And>
        <Category>Development</Category>
      </And>
      <Filename>emacs.desktop</Filename>
    </Include>
  </Menu>

  <!-- Education -->
  <Menu>
    <Name>Education</Name>
    <Directory>xfce-education.directory</Directory>
    <Include>
      <And>
        <Category>Education</Category>
      </And>
    </Include>
  </Menu>

  <!-- Games -->
  <Menu>
    <Name>Games</Name>
    <Directory>xfce-games.directory</Directory>
    <Include>
      <And>
        <Category>Game</Category>
      </And>
    </Include>
  </Menu>

  <!-- Graphics -->
  <Menu>
    <Name>Graphics</Name>
    <Directory>xfce-graphics.directory</Directory>
    <Include>
      <And>
        <Category>Graphics</Category>
      </And>
    </Include>
  </Menu>

  <!-- Internet (without mail applications) -->
  <Menu>
    <Name>Internet</Name>
    <Directory>xfce-network.directory</Directory>
    <Include>
      <And>
        <Category>Network</Category>
        <Not><Category>Email</Category></Not>
      </And>
    </Include>
  </Menu>

  <!-- Multimedia -->
  <Menu>
    <Name>Multimedia</Name>
    <Directory>xfce-multimedia.directory</Directory>
    <Include>
      <And>
        <Category>AudioVideo</Category>
      </And>
    </Include>
  </Menu>

  <!-- Office -->
  <Menu>
    <Name>Office</Name>
    <Directory>xfce-office.directory</Directory>
    <Include>
      <And>
        <Category>Office</Category>
      </And>
    </Include>
  </Menu>

  <!-- ChaOS Tools submenu -->
  <Menu>
    <Name>ChaOS Tools</Name>
    <Directory>chaos-tools.directory</Directory>
    
    <!-- Information Gathering -->
    <Menu>
      <Name>Information Gathering</Name>
      <Directory>chaos-info-gathering.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-InfoGathering</Category>
        </And>
      </Include>
    </Menu>

    <!-- Vulnerability Analysis -->
    <Menu>
      <Name>Vulnerability Analysis</Name>
      <Directory>chaos-vulnerability-analysis.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-VulnAnalysis</Category>
        </And>
      </Include>
    </Menu>

    <!-- Web Application Analysis -->
    <Menu>
      <Name>Web Application Analysis</Name>
      <Directory>chaos-web-analysis.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-WebAnalysis</Category>
        </And>
      </Include>
    </Menu>

    <!-- Database Assessment -->
    <Menu>
      <Name>Database Assessment</Name>
      <Directory>chaos-database-assessment.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-DatabaseAssessment</Category>
        </And>
      </Include>
    </Menu>

    <!-- Password Attacks -->
    <Menu>
      <Name>Password Attacks</Name>
      <Directory>chaos-password-attacks.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-PasswordAttacks</Category>
        </And>
      </Include>
    </Menu>

    <!-- Wireless Attacks -->
    <Menu>
      <Name>Wireless Attacks</Name>
      <Directory>chaos-wireless-attacks.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-WirelessAttacks</Category>
        </And>
      </Include>
    </Menu>

    <!-- Exploitation Tools -->
    <Menu>
      <Name>Exploitation Tools</Name>
      <Directory>chaos-exploitation.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-Exploitation</Category>
        </And>
      </Include>
    </Menu>

    <!-- Sniffing & Spoofing -->
    <Menu>
      <Name>Sniffing & Spoofing</Name>
      <Directory>chaos-sniffing-spoofing.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-SniffingSpoofing</Category>
        </And>
      </Include>
    </Menu>

    <!-- Post Exploitation -->
    <Menu>
      <Name>Post Exploitation</Name>
      <Directory>chaos-post-exploitation.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-PostExploitation</Category>
        </And>
      </Include>
    </Menu>

    <!-- Forensics -->
    <Menu>
      <Name>Forensics</Name>
      <Directory>chaos-forensics.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-Forensics</Category>
        </And>
      </Include>
    </Menu>

    <!-- Reverse Engineering -->
    <Menu>
      <Name>Reverse Engineering</Name>
      <Directory>chaos-reverse-engineering.directory</Directory>
      <Include>
        <And>
          <Category>X-ChaOS-ReverseEngineering</Category>
        </And>
      </Include>
    </Menu>

  </Menu>

  <!-- System -->
  <Menu>
    <Name>System</Name>
    <Directory>xfce-system.directory</Directory>
    <Include>
      <And>
        <Category>System</Category>
        <Not><Category>Settings</Category></Not>
      </And>
    </Include>
  </Menu>

  <!-- Settings -->
  <Menu>
    <Name>Settings</Name>
    <Directory>xfce-settings.directory</Directory>
    <Include>
      <And>
        <Category>Settings</Category>
      </And>
    </Include>
  </Menu>

  <!-- Other -->
  <Menu>
    <Name>Other</Name>
    <Directory>xfce-other.directory</Directory>
    <OnlyUnallocated/>
    <Include>
      <And>
        <Not><Category>Core</Category></Not>
        <Not><Category>Settings</Category></Not>
        <Not><Category>Screensaver</Category></Not>
      </And>
    </Include>
  </Menu>

</Menu>
EOF

# Copy all directory entries to system-wide location
print_status "Copying directory entries to system-wide location..."
cp "$USER_HOME/.local/share/desktop-directories/"*.directory "/usr/share/desktop-directories/" 2>/dev/null || true

# Copy applications menu to system-wide location
print_status "Installing system-wide applications menu..."
cp "$USER_HOME/.config/menus/applications.menu" "/etc/xdg/menus/"

# Force refresh of menu cache
print_status "Refreshing menu cache..."
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$USER_HOME/.local/share/applications" 2>/dev/null || true
    update-desktop-database "/usr/share/applications" 2>/dev/null || true
fi

print_success "Application menu configuration completed!"
print_status "Changes made:"
print_status "- Removed mail client from Internet menu"
print_status "- Created ChaOS Tools submenu"
print_status "- Added Red Team Tools categories:"
print_status "  • Information Gathering"
print_status "  • Vulnerability Analysis"
print_status "  • Web Application Analysis"
print_status "  • Database Assessment"
print_status "  • Password Attacks"
print_status "  • Wireless Attacks"
print_status "  • Exploitation Tools"
print_status "  • Sniffing & Spoofing"
print_status "  • Post Exploitation"
print_status "  • Forensics"
print_status "  • Reverse Engineering"
