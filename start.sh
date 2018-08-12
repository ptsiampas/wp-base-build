#!/bin/bash

WP_USER=33
WP_GROUP=33
MYSQL_USER=999
MYSQL_GROUP=999
MYSQL_DIR="$(pwd)/data/db"
WP_DIR="$(pwd)/data/wp"

# shellcheck source=/dev/null
source "$(pwd)/env"
mkdir -p "$MYSQL_DIR"
mkdir -p "$WP_DIR"

[ $(stat -c '%u' "$MYSQL_DIR") -ne $MYSQL_USER ] || [ $(stat -c '%g' "$MYSQL_DIR") -ne $MYSQL_GROUP ] && sudo chown "$MYSQL_USER":"$MYSQL_GROUP" "$MYSQL_DIR"
[ $(stat -c '%u' "$WP_DIR") -ne "$WP_USER" ] || [ $(stat -c '%g' "$WP_DIR") -ne "$WP_GROUP" ] && sudo chown "$WP_USER":"$WP_GROUP" "$WP_DIR"

env $(cat env | grep ^[A-Z] | xargs) docker stack deploy --with-registry-auth -c docker-compose.yml "wp-${CLIENT_NAME}"
