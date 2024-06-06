#!/bin/bash

# Remove any existing lock files
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1
rm -rf /tmp/.X11-unix
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Start Xvfb with higher resolution and DPI
Xvfb :1 -screen 0 3840x2160x16 -dpi 120 &

# Wait for Xvfb to start
sleep 3

# Create and set XDG_RUNTIME_DIR
mkdir -p /tmp/runtime-root
chmod 700 /tmp/runtime-root

# Set environment variables
export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-root

# Load X resources
xrdb -merge ~/.Xresources

# Start the openbox window manager with custom configuration
openbox --config-file /root/.config/openbox/rc.xml &
# openbox &

# Start x11vnc
x11vnc -display :1 -nopw -forever &

# Keep the container running and provide an interactive bash shell
exec /bin/bash
