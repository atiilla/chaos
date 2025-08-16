# ChaOS - Controlled Havoc for Red Teamers

![ChaOS Logo](branding_assets/chaos.png)

A custom Linux distribution focused on privacy and red team operations, built on Debian with XFCE desktop environment.

## Overview

![grub screen](grub_screen.png)

ChaOS is designed as a specialized Linux distribution for security professionals, penetration testers, and red team operators. It combines the stability of Debian with privacy-focused tools and a lightweight XFCE desktop environment.

## Features Planned
- A lightweight XFCE desktop environment
- Privacy-focused tools and configurations
- Pre-configured for red team operations
- Custom tools and scripts for red team engagements


## Project Structure

```
ChaOS/
├── branding_assets/           # All ChaOS branding images
│   ├── wallpaper.png         # Desktop wallpaper
│   ├── grub_background.png   # GRUB boot background
│   ├── lightdm_background.png # Login screen background
│   ├── splash.png            # Boot splash image
│   ├── logo.png              # ChaOS logo
│   ├── chaos-icon.ico        # Icon file
│   ├── lock.png              # Lock screen background
│   └── theme.txt             # GRUB theme configuration
├── grub2-themes/
│   └── ChaOS/                # Custom GRUB theme
│       ├── theme.txt         # GRUB theme configuration
│       ├── background.png    # GRUB background
│       └── install.sh        # GRUB theme installer
├── xfce-config/              # XFCE configuration and scripts
│   ├── install-xfce.sh       # Main XFCE installer with ChaOS branding
│   └── customize-desktop.sh  # User desktop customization script
├── build-chaos.sh            # Main ISO builder script
├── quick-setup.sh            # Quick setup for testing
└── README.md                 # This file

## 🚀 Quick Start

### Option 1: Full ISO Build (Recommended)

Build a complete ChaOS Linux ISO:

```bash
sudo ./build-chaos.sh
```

This will create a bootable ISO in the `output/` directory that you can:
- Test in a virtual machine
- Write to a USB drive
- Boot on physical hardware

### Option 2: Apply ChaOS Theming to Existing System

If you already have a Debian/Ubuntu system with XFCE, you can apply ChaOS theming:

```bash
# Install XFCE and apply ChaOS branding (run as root)
sudo ./xfce-config/install-xfce.sh

# Apply GRUB theme (run as root)
sudo ./grub2-themes/ChaOS/install.sh

# Customize current user's desktop (run as regular user)
./xfce-config/customize-desktop.sh
```

### Option 3: Quick Testing Setup

For quick testing on current system:

```bash
./quick-setup.sh
```

## Build Requirements

The build process requires the following packages (automatically installed):

- `debootstrap` - Bootstrap Debian base system
- `squashfs-tools` - Create compressed filesystem
- `xorriso` - Create ISO images
- `isolinux` / `syslinux-efi` - Boot loaders
- `grub-pc-bin` / `grub-efi-amd64-bin` - GRUB bootloader
- `mtools` / `dosfstools` - File system tools

## What's Included in ChaOS

### Base System
- Linux kernel with firmware support
- SystemD init system
- Network Manager for connectivity
- Bluetooth and audio support
- Live boot capabilities

### Desktop Environment
- XFCE 4.18 desktop environment
- Custom ChaOS panel configuration
- Dark theme by default
- ChaOS-branded wallpaper and icons
- File manager (Thunar) with plugins

### Applications
- Firefox ESR web browser
- File archiver (file-roller)
- Audio control (PulseAudio + pavucontrol)
- Bluetooth manager (blueman)
- Package manager (Synaptic)
- Terminal emulator (XFCE Terminal)
- Screenshot tool
- Text editor (Nano, Vim)

### Development Tools
- Git version control
- Curl and wget
- SSH client/server
- Development headers
- Package building tools

## 🎨 Customization

### Modifying Branding

1. Replace images in `branding_assets/` with your own:
   - Keep the same filenames
   - Maintain similar aspect ratios
   - Use PNG format for best compatibility

2. Update `grub2-themes/ChaOS/theme.txt` to modify GRUB appearance

3. Modify `xfce-config/install-xfce.sh` to change default applications or settings

### Adding Software

Edit the package lists in `build-chaos.sh` to include additional software:

```bash
# In the chroot setup section, add packages to:
apt install -y \
    your-package-here \
    another-package
```

## 🔧 Troubleshooting

### Build Issues

1. **Permission errors**: Make sure to run build script as root (`sudo`)
2. **Network issues**: Check internet connectivity during build
3. **Disk space**: Ensure at least 8GB free space in `/tmp`
4. **Package conflicts**: Update your host system before building

### Runtime Issues

1. **Graphics problems**: Try adding `nomodeset` to kernel parameters
2. **WiFi not working**: Install additional firmware packages
3. **Audio issues**: Check PulseAudio configuration
4. **GRUB theme not applied**: Run the install script manually

### Boot Issues

1. **ISO won't boot**: 
   - Verify ISO integrity with checksums
   - Try writing to USB with `dd` instead of other tools
   - Test in virtual machine first

2. **Black screen after boot**:
   - Remove `quiet splash` from kernel parameters
   - Add `nomodeset` parameter

## System Requirements

### Minimum Requirements
- 64-bit processor (x86_64)
- 2GB RAM
- 20GB disk space
- UEFI or Legacy BIOS support

### Recommended Requirements
- 4GB+ RAM
- 40GB+ disk space
- Dedicated graphics card
- USB 3.0 for live USB

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is open source. Individual components may have their own licenses:
- Debian components: Various open source licenses
- XFCE: GPL v2+
- GRUB: GPL v3+
- Custom scripts: GPL v3+

## Resources

- [Debian Live Manual](https://live-team.pages.debian.net/live-manual/)
- [XFCE Documentation](https://docs.xfce.org/)
- [GRUB Theming Guide](https://wiki.archlinux.org/title/GRUB/Tips_and_tricks#Theme)
- [Plymouth Themes](https://wiki.archlinux.org/title/Plymouth)

## 🐛 Bug Reports

Please report issues with:
1. Steps to reproduce
2. Expected vs actual behavior
3. System information
4. Log files if applicable

---

**ChaOS Linux** - *Art is the triumph over chaos* ✨
