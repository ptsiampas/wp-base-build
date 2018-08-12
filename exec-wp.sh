#!/bin/bash
source "$(pwd)/env"

docker stack ps "wp-${CLIENT_NAME}" > /dev/null 2>&1
if [ $? -eq 0 ];then
    echo "stack running - executing command"
else
    echo "could not find stack wp-${CLIENT_NAME}! Make sure it's running."
    exit
fi

CLI_IMAGE="wordpress:cli-php7.1"

DATA=$(docker service inspect --pretty  "wp-${CLIENT_NAME}_wordpress")

NETWORK=$(echo "$DATA" | sed -n 's/Networks:\s\(.*\)/\1/p' | tr -d '[:space:]')
VOL_SRC=$(echo "$DATA" | sed -n 's/Source\s=\s\(.*\)/\1/p' | tr -d '[:space:]')
VOL_TRG=$(echo "$DATA" | sed -n 's/Target\s=\s\(.*\)/\1/p' | tr -d '[:space:]')

echo "container: wp-${CLIENT_NAME}_wordpress"
echo "network: $NETWORK"
echo "volume: $VOL_SRC:$VOL_TRG"

docker run -it --rm \
--user 33:33 \
--volume "$VOL_SRC:$VOL_TRG" \
--network "$NETWORK" \
$CLI_IMAGE "$@"
