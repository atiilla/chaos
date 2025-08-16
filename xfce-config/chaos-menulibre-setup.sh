#!/bin/bash

# ChaOS MenuLibre Setup Script
# Creates menu entries using MenuLibre and manual configuration

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

print_status "Setting up ChaOS Tools menu with MenuLibre..."

# Create system and user directories
mkdir -p /usr/share/desktop-directories
mkdir -p /usr/share/applications
mkdir -p /etc/xdg/menus
mkdir -p /etc/xdg/menus/applications-merged
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/desktop-directories
mkdir -p ~/.config/menus

# Create ChaOS Tools main directory entry
cat > /usr/share/desktop-directories/chaos-tools.directory << 'EOF'
[Desktop Entry]
Version=1.0
Type=Directory
Name=ChaOS Tools
Name[en_US]=ChaOS Tools
Comment=Security and penetration testing tools
Comment[en_US]=Security and penetration testing tools
Icon=/usr/share/pixmaps/chaos/chaos-icon.ico
EOF

# Create category directories with proper formatting
categories=(
    "chaos-info-gathering:Information Gathering:Tools for reconnaissance and information gathering:applications-internet"
    "chaos-vulnerability-analysis:Vulnerability Analysis:Tools for vulnerability scanning and analysis:applications-debugging"
    "chaos-web-analysis:Web Application Analysis:Tools for web application security testing:applications-internet"
    "chaos-database-assessment:Database Assessment:Tools for database security assessment:applications-office"
    "chaos-password-attacks:Password Attacks:Tools for password cracking and attacks:dialog-password"
    "chaos-wireless-attacks:Wireless Attacks:Tools for wireless network security testing:network-wireless"
    "chaos-exploitation:Exploitation Tools:Tools for exploitation and payload generation:applications-system"
    "chaos-sniffing-spoofing:Sniffing & Spoofing:Tools for network sniffing and spoofing:network-wired"
    "chaos-post-exploitation:Post Exploitation:Tools for post-exploitation activities:applications-system"
    "chaos-forensics:Forensics:Tools for digital forensics and analysis:applications-science"
    "chaos-reverse-engineering:Reverse Engineering:Tools for reverse engineering and binary analysis:applications-development"
)

print_status "Creating category directory entries..."
for category in "${categories[@]}"; do
    IFS=':' read -r id name comment icon <<< "$category"
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

# Create sample applications for each category to make them visible
print_status "Creating placeholder applications for categories..."

# Information Gathering tools
cat > /usr/share/applications/nmap-chaos.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Nmap Network Scanner
Comment=Network discovery and security auditing
Exec=nmap
Icon=network-wired
Terminal=true
Categories=Network;Security;X-ChaOS-InfoGathering;
EOF

cat > /usr/share/applications/whois-chaos.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Whois Domain Lookup
Comment=Domain information lookup tool
Exec=sh -c 'read -p "Enter domain: " domain && whois $domain && read -p "Press Enter to continue..."'
Icon=applications-internet
Terminal=true
Categories=Network;Security;X-ChaOS-InfoGathering;
EOF

# Vulnerability Analysis
cat > /usr/share/applications/openvas-chaos.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=OpenVAS Scanner
Comment=Vulnerability assessment scanner
Exec=sh -c 'echo "OpenVAS - Install with: sudo apt install openvas" && read -p "Press Enter to continue..."'
Icon=applications-debugging
Terminal=true
Categories=Security;X-ChaOS-VulnAnalysis;
EOF

# Password Attacks
cat > /usr/share/applications/john-chaos.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=John the Ripper
Comment=Password cracking tool
Exec=sh -c 'john --help && read -p "Press Enter to continue..."'
Icon=dialog-password
Terminal=true
Categories=Security;X-ChaOS-PasswordAttacks;
EOF

# Wireless Attacks
cat > /usr/share/applications/aircrack-chaos.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Aircrack-ng Suite
Comment=Wireless network security testing
Exec=sh -c 'aircrack-ng --help && read -p "Press Enter to continue..."'
Icon=network-wireless
Terminal=true
Categories=Network;Security;X-ChaOS-WirelessAttacks;
EOF

# Web Application Analysis
cat > /usr/share/applications/sqlmap-chaos.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=SQLmap
Comment=SQL injection testing tool
Exec=sh -c 'echo "SQLmap - Install with: sudo apt install sqlmap" && read -p "Press Enter to continue..."'
Icon=applications-internet
Terminal=true
Categories=Security;X-ChaOS-WebAnalysis;
EOF

# Exploitation Tools
cat > /usr/share/applications/metasploit-chaos.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Metasploit Framework
Comment=Penetration testing framework
Exec=sh -c 'echo "Metasploit - Install from: https://www.metasploit.com/" && read -p "Press Enter to continue..."'
Icon=applications-system
Terminal=true
Categories=Security;X-ChaOS-Exploitation;
EOF

# Sniffing & Spoofing
cat > /usr/share/applications/wireshark-chaos.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wireshark Network Analyzer
Comment=Network protocol analyzer
Exec=sh -c 'echo "Wireshark - Install with: sudo apt install wireshark" && read -p "Press Enter to continue..."'
Icon=network-wired
Terminal=true
Categories=Network;Security;X-ChaOS-SniffingSpoofing;
EOF

# Create the main menu configuration
print_status "Creating ChaOS Tools menu configuration..."
cat > /etc/xdg/menus/applications-merged/chaos-tools.menu << 'EOF'
<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
  "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">

<Menu>
  <Name>Applications</Name>
  
  <Menu>
    <Name>ChaOS-Tools</Name>
    <Directory>chaos-tools.directory</Directory>
    
    <Menu>
      <Name>Information-Gathering</Name>
      <Directory>chaos-info-gathering.directory</Directory>
      <Include>
        <Category>X-ChaOS-InfoGathering</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Vulnerability-Analysis</Name>
      <Directory>chaos-vulnerability-analysis.directory</Directory>
      <Include>
        <Category>X-ChaOS-VulnAnalysis</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Web-Application-Analysis</Name>
      <Directory>chaos-web-analysis.directory</Directory>
      <Include>
        <Category>X-ChaOS-WebAnalysis</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Database-Assessment</Name>
      <Directory>chaos-database-assessment.directory</Directory>
      <Include>
        <Category>X-ChaOS-DatabaseAssessment</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Password-Attacks</Name>
      <Directory>chaos-password-attacks.directory</Directory>
      <Include>
        <Category>X-ChaOS-PasswordAttacks</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Wireless-Attacks</Name>
      <Directory>chaos-wireless-attacks.directory</Directory>
      <Include>
        <Category>X-ChaOS-WirelessAttacks</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Exploitation-Tools</Name>
      <Directory>chaos-exploitation.directory</Directory>
      <Include>
        <Category>X-ChaOS-Exploitation</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Sniffing-Spoofing</Name>
      <Directory>chaos-sniffing-spoofing.directory</Directory>
      <Include>
        <Category>X-ChaOS-SniffingSpoofing</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Post-Exploitation</Name>
      <Directory>chaos-post-exploitation.directory</Directory>
      <Include>
        <Category>X-ChaOS-PostExploitation</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Forensics</Name>
      <Directory>chaos-forensics.directory</Directory>
      <Include>
        <Category>X-ChaOS-Forensics</Category>
      </Include>
    </Menu>

    <Menu>
      <Name>Reverse-Engineering</Name>
      <Directory>chaos-reverse-engineering.directory</Directory>
      <Include>
        <Category>X-ChaOS-ReverseEngineering</Category>
      </Include>
    </Menu>

  </Menu>
  
</Menu>
EOF

# Remove mail applications
cat > /etc/xdg/menus/applications-merged/no-mail.menu << 'EOF'
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

# Update desktop database
print_status "Updating desktop database..."
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database /usr/share/applications
    update-desktop-database ~/.local/share/applications 2>/dev/null || true
fi

# Set proper permissions
chmod 644 /usr/share/desktop-directories/*.directory
chmod 644 /usr/share/applications/*-chaos.desktop
chmod 644 /etc/xdg/menus/applications-merged/*.menu

print_success "ChaOS Tools menu setup completed!"
print_status "Created:"
print_status "- ChaOS Tools main menu"
print_status "- 11 Red Team tool categories with sample applications"
print_status "- Removed mail client from Internet menu"
print_status "- Menu should appear after panel restart or logout/login"

# Try to restart panel if we're in a graphical session
if [ -n "$DISPLAY" ] && command -v xfce4-panel >/dev/null 2>&1; then
    print_status "Attempting to restart XFCE panel..."
    killall xfce4-panel 2>/dev/null || true
    sleep 2
    nohup xfce4-panel >/dev/null 2>&1 &
fi
