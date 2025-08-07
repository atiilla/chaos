# ChaOS - Controlled Havoc for Red Teamers

![ChaOS Logo](Pictures/chaos.png)

A custom Linux distribution focused on privacy and red team operations, built on Debian with XFCE desktop environment.

## Overview

ChaOS is designed as a specialized Linux distribution for security professionals, penetration testers, and red team operators. It combines the stability of Debian with privacy-focused tools and a lightweight XFCE desktop environment.

## Features
It is still in development, but aims to provide:
- A lightweight XFCE desktop environment
- Privacy-focused tools and configurations
- Custom branding and theming
- Easy-to-use installer based on Calamares
- Pre-configured for red team operations
- Support for both live boot and installation

## Building ChaOS

### Prerequisites

Install the required tools:

```bash
sudo apt update
sudo apt install -y live-build squashfs-tools live-boot live-config xorriso isolinux netselect-apt
```

### Building the ISO

1. Clone this repository:
   ```bash
   git clone https://github.com/atiilla/chaos.git
   cd chaos
   ```

2. Run the build scripts:
   ```bash
   ./scripts/clean.sh
   ./scripts/config.sh
   ./scripts/build.sh
   ```

3. The resulting ISO will be created in the project root directory as `live-image-amd64.hybrid.iso`.

### Testing the ISO

Test the ISO using QEMU:

```bash
qemu-system-x86_64 -m 4096 -cdrom live-image-amd64.hybrid.iso
```

Or burn it to a USB drive and boot a physical machine.

## Project Structure

- `config/`: Configuration files for live-build
  - `package-lists/`: Lists of packages to include
  - `includes.chroot/`: Files to include in the live system
- `Pictures/`: Branding images and logos
- `scripts/`: Build and configuration scripts

## Future Enhancements

- Add specialized red team tools
- Customize Calamares installer and theming
- Harden for privacy (AppArmor, dnscrypt-proxy, tor)
- Build chaos-tools.deb package for custom tools

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
