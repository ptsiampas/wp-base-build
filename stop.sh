#!/bin/bash
# shellcheck source=/dev/null
source "$(pwd)/env"
docker stack rm  "wp-${CONTAINER_NAME}"
