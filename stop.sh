#!/bin/bash
# shellcheck source=/dev/null
source "$(pwd)/env"
docker stack rm  "wp-${CLIENT_NAME}"
