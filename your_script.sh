#!/bin/bash

set -euo pipefail

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $@"
}

# Update package lists
log "Updating package lists"
sudo apt-get update

# Download necessary files
log "Downloading OVMF BIOS, Windows ISO, and ngrok"
wget -O bios64.bin "https://github.com/BlankOn/ovmf-blobs/raw/master/bios64.bin"
wget -O win.iso "https://go.microsoft.com/fwlink/p/?LinkID=2195404&clcid=0x409&culture=en-us&country=US"
wget -O ngrok.tgz "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"

# Extract ngrok
log "Extracting ngrok"
tar -xf ngrok.tgz

# Set ngrok authtoken
log "Setting ngrok authtoken"
./ngrok authtoken <insert authtoken here>

# Start ngrok for TCP tunneling
log "Starting ngrok for TCP tunneling"
./ngrok tcp 5900 &

# Install QEMU-KVM
log "Installing QEMU-KVM"
sudo apt install qemu-kvm -y

# Create a raw image for the Windows installation
log "Creating a raw image for the Windows installation"
qemu-img create -f raw win.img 32G

# Start the QEMU virtual machine
log "Starting the QEMU virtual machine"
sudo qemu-system-x86_64 -m 12G -smp 4 -cpu host -boot order=c -drive file=win.iso,media=cdrom -drive file=win.img,format=raw -device usb-ehci,id=usb,bus=pci.0,addr=0x4 -device usb-tablet -vnc :0 -smp cores=4 -device e1000,netdev=n0 -netdev user,id=n0 -vga qxl -accel kvm -bios bios64.bin &

# Wait for ngrok to start
sleep 5

# Get the ngrok public URL for VNC
log "Getting the ngrok public URL for VNC"
VNC_URL=$(curl --silent http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url')
log "VNC URL: $VNC_URL"

# Sleep indefinitely to keep the script running
log "Script is running indefinitely. Press Ctrl+C to stop."
tail -f /dev/null
