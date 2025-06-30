docker run -it --rm \
    -e HF_TOKEN=$HF_TOKEN \
    -e HF_HOME=$HF_HOME \
    -e WANDB_API_KEY=$WANDB_API_KEY \
    --network=host \
    --mount type=bind,source=$HF_HOME/../,target=$HF_HOME/../ \
    --mount type=bind,source=$(pwd)/pyproject.toml,target=/workspace/pyproject.toml \
    --mount type=bind,source=$(pwd)/src,target=/workspace/src \
    --mount type=bind,source=$(pwd)/examples,target=/workspace/examples \
    --mount type=bind,source=$(pwd)/run_train.py,target=/workspace/run_train.py \
    --ipc=host \
    --ulimit memlock=-1 \
    --ulimit stack=67108864 \
    --gpus all \
    nanotron:latest
