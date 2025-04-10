ARG BASE_IMAGE
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on \
    SHELL=/bin/bash

# Create and use the Python venv
WORKDIR /
RUN python3 -m venv --system-site-packages /venv

# Install torch and xformers
ARG INDEX_URL
ARG TORCH_VERSION
ARG XFORMERS_VERSION
RUN source /venv/bin/activate && \
    pip3 install --no-cache-dir torch==${TORCH_VERSION} torchvision torchaudio --index-url ${INDEX_URL} && \
    pip3 install --no-cache-dir xformers==${XFORMERS_VERSION} --index-url ${INDEX_URL} && \
    deactivate

# Clone the git repo of Wan2.1 and set version
ARG WAN_COMMIT
RUN git clone https://github.com/Wan-Video/Wan2.1.git && \
    cd /Wan2.1 && \
    git checkout ${WAN_COMMIT}

# Install the dependencies for Wan2.1
WORKDIR /Wan2.1
RUN source /venv/bin/activate && \
    pip3 install -r requirements.txt && \
    pip3 install . && \
    pip3 install huggingface_hub && \
    deactivate

# Install models
RUN source /venv/bin/activate && \
    huggingface-cli download Wan-AI/Wan2.1-T2V-1.3B \
      --local-dir pretrained_models \
      --local-dir-use-symlinks False && \
    deactivate

# Remove existing SSH host keys
RUN rm -f /etc/ssh/ssh_host_*

# NGINX Proxy
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Set template version
ARG RELEASE
ENV TEMPLATE_VERSION=${RELEASE}

# Copy the scripts
WORKDIR /
COPY --chmod=755 scripts/* ./

# Start the container
SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/start.sh" ]
