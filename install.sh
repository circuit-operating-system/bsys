#!/bin/bash

# Return codes:
#   0 - OK
#   1 - Insufficient permissions
#   2 - File conflict

# Exit on any command failure
set -e

# Check if we have root privileges
if [[ ! $(whoami) == "root" ]]; then
    echo "(X) Installer script requires root privileges." >&2
    exit 1
fi

# Check if -u / --uninstall option is passed
if [[ "$1" == "-u" || "$1" == "--uninstall" ]]; then
    rm -rf /opt/bsys
    rm -f /bin/bsys
    echo "=> Uninstall successful."
    exit
fi

# Check if files are stored at the install dir
if [[ -d "/opt/bsys" ]]; then
    echo "(X) Conflict at install directory. Please move /opt/bsys contents and remove the directory." >&2
    exit 2
fi

# Make the install directory
mkdir /opt/bsys /opt/bsys/bin /opt/bsys/etc

# Copy files to install dir
cp ./bin/bsys /opt/bsys/bin/bsys
cp ./etc/linker.ld /opt/bsys/etc/linker.ld

# Link bsys to /bin
ln -s /opt/bsys/bin/bsys /bin/bsys

# Success message
echo "=> Successful! Use $0 -u to uninstall."