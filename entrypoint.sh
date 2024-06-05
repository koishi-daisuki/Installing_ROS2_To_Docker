#!/bin/bash

# Remove any existing lock files
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1
rm -rf /tmp/.X11-unix
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Start Xvfb
Xvfb :1 -screen 0 1024x768x16 &

# Wait for Xvfb to start
sleep 3

# Create and set XDG_RUNTIME_DIR
mkdir -p /tmp/runtime-root
chmod 700 /tmp/runtime-root

# Set environment variables
export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-root

# Start the openbox window manager
openbox &

# Start x11vnc
x11vnc -display :1 -nopw -forever &

# Keep the container running and provide an interactive bash shell
exec /bin/bash
