#!/bin/bash

if [ ! -f ../env ]; then
    echo "Unable to file env file."
    exit
fi

source ../env

MYSQL_ROOT_PASS=""
WP_DB_USER=""
WP_DB_PASS=""

echo ${MYSQL_ROOT_PASS} | docker secret create ${CONTAINER_NAME}-msql-root -;
echo ${WP_DB_USER} | docker secret create ${CONTAINER_NAME}-wp-user -;
echo ${WP_DB_PASS} | docker secret create ${CONTAINER_NAME}-wp-user-pass -;


