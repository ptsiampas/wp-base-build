#!/bin/bash
#
source "$(pwd)/env"
DEST_DIR=/var/data/client-data/wordpress
FILE_LIST="config-items.sh exec-wp.sh fix-wordpress-permissions.sh start.sh stop.sh site_nginx.conf site.template data tools"

mkdir -p "$(pwd)/${CONTAINER_NAME}"

for file in $FILE_LIST;do
    cp -r "$(pwd)/$file" "${DEST_DIR}/${CONTAINER_NAME}/$file"
done

export CONTAINER_NAME=$CONTAINER_NAME
export TRAEFIK_NETWORK=$TRAEFIK_NETWORK
envsubst '${CONTAINER_NAME},${TRAEFIK_NETWORK}'  < docker-compose.yml > "${DEST_DIR}/${CONTAINER_NAME}/${CONTAINER_NAME}.yml"