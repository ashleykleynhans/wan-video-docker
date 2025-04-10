#!/usr/bin/env bash

export PYTHONUNBUFFERED=1
echo "Starting Wan2.1"
source /venv/bin/activate
cd /workspace/Wan2.1
TCMALLOC="$(ldconfig -p | grep -Po "libtcmalloc.so.\d" | head -n 1)"
export LD_PRELOAD="${TCMALLOC}"
export GRADIO_SERVER_NAME="0.0.0.0"
export GRADIO_SERVER_PORT="3001"
export HF_HOME="/workspace"
nohup python3 gradio/t2v_1.3B_singleGPU.py \
    --prompt_extend_method 'local_qwen' \
    --ckpt_dir /workspace/Wan2.1/pretrained_models > /workspace/logs/wan.log 2>&1 &
echo "Wan2.1 started"
echo "Log file: /workspace/logs/wan.log"
deactivate
