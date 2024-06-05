# ROS in Arm64 Docker Setup

![Build Status](https://github.com/koishi-daisuki/Installing_ROS2_To_Docker/actions/workflows/main.yml/badge.svg)


## Contents

- `Dockerfile`: Instructions to build the Docker image.
- `entrypoint.sh`: Script to set up and start Xvfb, Openbox, and x11vnc.
- `menu.xml`: Openbox menu configuration file.

## Getting Started

### Prerequisites

- Docker installed on your host machine.[Install Docker](https://docs.docker.com/get-docker/)
- Arm64 architecture (tested on macos sonoma 14.5 M3 Max)
- VNC client installed on your local machine to connect to the VNC server running in the Docker container. Recommandation:![realvnc](https://www.realvnc.com/en/connect/download/)

### Build the Docker Image

1. Clone this repository:
    ```bash
    git clone https://github.com/koishi-daisuki/Installing_ROS2_To_Docker
    cd Installing_ROS2_To_Docker
    ```

2. Build the Docker image:
    ```bash
    docker build -t ros2-rolling .
    ```

### Run the Docker Container

To run the Docker container with a VNC access:

```bash
docker run -it --rm \
    -p 5900:5900 \
    --name ros2_rolling \
    ros2-rolling
```
access to VNC:
localhost:5900
