#!/bin/bash

# ChaOS Tools Menu Installer
# This script adds the ChaOS Tools menu to the existing XFCE menu structure

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

print_status "Installing ChaOS Tools menu..."

# Create system-wide directory entries
mkdir -p /usr/share/desktop-directories

# ChaOS Tools main directory
cat > /usr/share/desktop-directories/chaos-tools.directory << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=ChaOS Tools
Name[en_US]=ChaOS Tools
Comment=Security and penetration testing tools
Comment[en_US]=Security and penetration testing tools
Icon=applications-security
EOF

# Create all category directories
categories=(
    "chaos-info-gathering|Information Gathering|Tools for reconnaissance and information gathering|applications-internet"
    "chaos-vulnerability-analysis|Vulnerability Analysis|Tools for vulnerability scanning and analysis|applications-debugging"
    "chaos-web-analysis|Web Application Analysis|Tools for web application security testing|applications-internet"
    "chaos-database-assessment|Database Assessment|Tools for database security assessment|applications-office"
    "chaos-password-attacks|Password Attacks|Tools for password cracking and attacks|dialog-password"
    "chaos-wireless-attacks|Wireless Attacks|Tools for wireless network security testing|network-wireless"
    "chaos-exploitation|Exploitation Tools|Tools for exploitation and payload generation|applications-system"
    "chaos-sniffing-spoofing|Sniffing & Spoofing|Tools for network sniffing and spoofing|network-wired"
    "chaos-post-exploitation|Post Exploitation|Tools for post-exploitation activities|applications-system"
    "chaos-forensics|Forensics|Tools for digital forensics and analysis|applications-science"
    "chaos-reverse-engineering|Reverse Engineering|Tools for reverse engineering and binary analysis|applications-development"
)

for category in "${categories[@]}"; do
    IFS='|' read -r id name comment icon <<< "$category"
    cat > "/usr/share/desktop-directories/${id}.directory" << EOF
[Desktop Entry]
Version=1.0
Type=Directory
Name=${name}
Name[en_US]=${name}
Comment=${comment}
Comment[en_US]=${comment}
Icon=${icon}
EOF
    print_status "Created ${name} category"
done

# Create the ChaOS Tools menu file
mkdir -p /etc/xdg/menus/applications-merged

cat > /etc/xdg/menus/applications-merged/chaos-tools.menu << 'EOF'
<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
  "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">

<Menu>
  <Name>Applications</Name>
  
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
  
</Menu>
EOF

# Remove mail applications from Internet menu
cat > /etc/xdg/menus/applications-merged/remove-mail.menu << 'EOF'
<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
  "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">

<Menu>
  <Name>Applications</Name>
  
  <Menu>
    <Name>Internet</Name>
    <Exclude>
      <Category>Email</Category>
    </Exclude>
  </Menu>
  
</Menu>
EOF

print_success "ChaOS Tools menu installed successfully!"
print_status "Menu will appear after XFCE restart or menu refresh"

# Try to refresh the menu cache
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database /usr/share/applications 2>/dev/null || true
fi

print_status "Created:"
print_status "- ChaOS Tools main menu"
print_status "- 11 Red Team tool categories"
print_status "- Mail client removal from Internet menu"
