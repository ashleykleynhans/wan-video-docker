<div align="center">

# Docker image for Wan: Open and Advanced Large-Scale Video Generative Models

</div>

## Installs

* Ubuntu 22.04 LTS
* CUDA 12.1
* Python 3.12.9
* [Wan2.1](
  https://github.com/Wan-Video/Wan2.1) v1.0.0
* Torch 2.5.1
* xformers 0.0.29.post1
* [Jupyter Lab](https://github.com/jupyterlab/jupyterlab)
* [code-server](https://github.com/coder/code-server)
* [runpodctl](https://github.com/runpod/runpodctl)
* [OhMyRunPod](https://github.com/kodxana/OhMyRunPod)
* [RunPod File Uploader](https://github.com/kodxana/RunPod-FilleUploader)
* [croc](https://github.com/schollz/croc)
* [rclone](https://rclone.org/)

## Available on RunPod

This image is designed to work on [RunPod](https://runpod.io?ref=2xxro4sy).
You can use my custom [RunPod template](
https://runpod.io/console/deploy?template=aeyibwyvzy&ref=2xxro4syy)
to launch it on RunPod.

## Building the Docker image

> [!NOTE]
> You will need to edit the `docker-bake.hcl` file and update `REGISTRY_USER`,
> and `RELEASE`.  You can obviously edit the other values too, but these
> are the most important ones.

```bash
# Clone the repo
git clone https://github.com/ashleykleynhans/wan-video-docker.git

# Log in to Docker Hub
docker login

# Build the image, tag the image, and push the image to Docker Hub
cd wan-video-docker
docker buildx bake -f docker-bake.hcl --push

# Same as above but customize registry/user/release:
REGISTRY=ghcr.io REGISTRY_USER=myuser RELEASE=my-release docker buildx \
    bake -f docker-bake.hcl --push
```

## Running Locally

### Install Nvidia CUDA Driver

- [Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
- [Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html)

### Start the Docker container

```bash
docker run -d \
  --gpus all \
  -v /workspace \
  -p 3000:3001 \
  -p 7777:7777 \
  -p 8888:8888 \
  -p 2999:2999 \
  -e VENV_PATH=/workspace/venvs/wan \
  ashleykza/wan2.1:latest
```

You can obviously substitute the image name and tag with your own.

## Ports

| Connect Port | Internal Port | Description          |
|--------------|---------------|----------------------|
| 3000         | 3001          | Wan2.1               |
| 7777         | 7777          | Code Server          |
| 8888         | 8888          | Jupyter Lab          |
| 2999         | 2999          | RunPod File Uploader |

## Environment Variables

| Variable             | Description                                      | Default                    |
|----------------------|--------------------------------------------------|----------------------------|
| JUPYTER_LAB_PASSWORD | Set a password for Jupyter lab                   | not set - no password      |
| DISABLE_AUTOLAUNCH   | Disable Wan2.1 from launching automatically      | (not set)                  |
| DISABLE_SYNC         | Disable syncing if using a RunPod network volume | (not set)                  |

## Logs

Wan2.1 creates a log file, and you can tail the log instead of
killing the service to view the logs.

| Application | Log file                |
|-------------|-------------------------|
| Wan2.1      | /workspace/logs/wan.log |

For example:

```bash
tail -f /workspace/logs/wan.log
```

## Community and Contributing

Pull requests and issues on [GitHub](https://github.com/ashleykleynhans/wan-video-docker)
are welcome. Bug fixes and new features are encouraged.

## Appreciate my work?

<a href="https://www.buymeacoffee.com/ashleyk" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
