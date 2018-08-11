#!/bin/bash

# shellcheck source=/dev/null
source "$(pwd)/env"
env $(cat env | grep ^[A-Z] | xargs) docker stack deploy --with-registry-auth -c docker-compose.yml "wp-${CLIENT_NAME}"
