#!/bin/bash

# GEOtop Dependency Checker and Installer
# Supports: Fedora, Ubuntu/Debian, Arch, openSUSE

set -e

echo "GEOtop Dependency Checker"
echo "========================="

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS"
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# Required packages by OS
case $OS in
    fedora)
        PACKAGES="gcc-c++ meson cmake boost-devel"
        INSTALL_CMD="sudo dnf install -y"
        CHECK_CMD="rpm -q"
        ;;
    ubuntu|debian)
        PACKAGES="g++ meson cmake libboost-all-dev"
        INSTALL_CMD="sudo apt-get install -y"
        CHECK_CMD="dpkg -l"
        ;;
    arch)
        PACKAGES="gcc meson cmake boost"
        INSTALL_CMD="sudo pacman -S --noconfirm"
        CHECK_CMD="pacman -Q"
        ;;
    opensuse*)
        PACKAGES="gcc-c++ meson cmake boost-devel"
        INSTALL_CMD="sudo zypper install -y"
        CHECK_CMD="rpm -q"
        ;;
    *)
        echo "Unsupported OS: $OS"
        echo "Required packages: g++, meson, cmake, boost development libraries"
        exit 1
        ;;
esac

echo "Checking dependencies..."
echo ""

MISSING=""

for pkg in $PACKAGES; do
    if $CHECK_CMD $pkg &>/dev/null; then
        echo "[OK] $pkg"
    else
        echo "[MISSING] $pkg"
        MISSING="$MISSING $pkg"
    fi
done

echo ""

if [ -z "$MISSING" ]; then
    echo "All dependencies installed."
    exit 0
else
    echo "Missing packages:$MISSING"
    echo ""
    read -p "Install missing packages? [y/N] " answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        $INSTALL_CMD $MISSING
        echo ""
        echo "Dependencies installed successfully."
    else
        echo "Please install manually:$MISSING"
        exit 1
    fi
fi
