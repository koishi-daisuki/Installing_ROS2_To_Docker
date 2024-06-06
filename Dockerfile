FROM arm64v8/ros:rolling-ros-core

# Set the environment as noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Optional (for users in China) using Tsinghua Mirror.
RUN sed -i 's|http://ports.ubuntu.com/ubuntu-ports|https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports|g' /etc/apt/sources.list

# Update package list and install basic dependencies
RUN until apt-get update; do echo "Retrying apt-get update..."; sleep 2; done && \
    until apt-get install -y curl gnupg2 lsb-release; do echo "Retrying apt-get install..."; sleep 2; done

# Add ros.key
RUN until curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg; do echo "Retrying curl..."; sleep 2; done

# Using ROS library and using Tsinghua Mirror
RUN echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Update package list
RUN until apt-get update; do echo "Retrying apt-get update..."; sleep 2; done

# Install dependencies
RUN until apt-get install -y \
    xvfb \
    x11vnc \
    ros-rolling-turtlesim \
    qtbase5-dev \
    qtbase5-dev-tools \
    qt5-qmake \
    libxcb-xinerama0 \
    mesa-utils \
    libgl1-mesa-dri \
    libglu1-mesa \
    x11-xkb-utils \
    xkb-data \
    xfonts-base \
    xfonts-100dpi \
    xfonts-75dpi \
    x11-apps; do echo "Retrying apt-get install..."; sleep 2; done

RUN until apt-get install -y \
    libx11-xcb1 \
    libfontconfig1 \
    openbox \
    libxrender1; do echo "Retrying apt-get install..."; sleep 2; done

RUN until apt install -y \
    ~nros-rolling-rqt*; do echo "Retrying apt-get install..."; sleep 2; done

# Set up X virtual framebuffer
RUN mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

# Set environment variables and add them to ~/.bashrc
RUN echo 'export QT_X11_NO_MITSHM=1' >> ~/.bashrc
RUN echo 'export QT_QPA_PLATFORM=xcb' >> ~/.bashrc
RUN echo 'export DISPLAY=:1' >> ~/.bashrc
RUN echo 'export XDG_RUNTIME_DIR=/tmp/runtime-root' >> ~/.bashrc
RUN echo 'export QT_SCALE_FACTOR=1.5' >> ~/.bashrc

# Create basic openbox configuration
RUN mkdir -p /etc/xdg/openbox /var/lib/openbox /root/.config/openbox
COPY config/etc/xdg/openbox/menu.xml /etc/xdg/openbox/menu.xml
COPY config/etc/xdg/openbox/menu.xml /var/lib/openbox/debian-menu.xml
COPY config/root/.config/openbox/rc.xml /root/.config/openbox/rc.xml

# Copy .Xresources file
COPY config/root/.Xresources /root/.Xresources

# Copy GTK settings file
COPY config/root/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini

# Copy and set the startup script
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Load ROS 2 environment variables
RUN echo "source /opt/ros/rolling/setup.bash" >> /root/.bashrc

# Ensure environment variables are loaded when shell starts
SHELL ["/bin/bash", "-c"]

ENTRYPOINT ["/entrypoint.sh"]
