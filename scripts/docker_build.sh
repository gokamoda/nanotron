docker build \
    -t nanotron:latest \
    --network=host \
    -f containers/Dockerfile \
    --progress plain \
    .