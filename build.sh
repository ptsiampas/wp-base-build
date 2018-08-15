#!/bin/bash
usage() { echo "Usage: $0 [-w] [-p] -d <domain.name>" 1>&2; exit 1; }
ENVIRONMENT="DEV"
SET_WWW=0
DEST_DIR=/home/petert/Downloads
FILE_LIST="config-items.sh exec-wp.sh fix-wordpress-permissions.sh start.sh stop.sh site_nginx.conf site.template data tools"

while getopts "wpd:" o; do
    case "${o}" in
        w)  SET_WWW=1
            ;;
        p)
            ENVIRONMENT="PROD"
            ;;
        d)
            DOMAIN=${OPTARG}
            ;;
        h|*)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "$DOMAIN" ] ; then
    echo "No Domain Given - Please provide one."
    usage
fi

if [ "${ENVIRONMENT}" == "PROD" ]; then
    TRAEFIK_NETWORK=infra-traefik_public
else
    TRAEFIK_NETWORK=public
fi

CONTAINER_NAME=$(echo "${DOMAIN}"| awk -F[.] '{print $1}')
BASE_DOMAIN="${DOMAIN}"
FULL_DIR="${DEST_DIR}/${BASE_DOMAIN}"

if [ "${SET_WWW}" -eq 1 ]; then
    DOMAIN="www.${DOMAIN}"
fi

echo "environment = ${ENVIRONMENT}"
echo "domain = ${DOMAIN}"
echo "traefik network = ${TRAEFIK_NETWORK}"

mkdir -p "$FULL_DIR"

# Create the environment file

# Copy files to directory
for file in $FILE_LIST;do
    cp -r "$(pwd)/$file" "${FULL_DIR}/$file"
done

# Generate the yaml file for swarm to deploy
export CONTAINER_NAME=$CONTAINER_NAME
export TRAEFIK_NETWORK=$TRAEFIK_NETWORK
envsubst '${CONTAINER_NAME},${TRAEFIK_NETWORK}'  < docker-compose.yml > "${FULL_DIR}/${CONTAINER_NAME}.yml"

if [ "${ENVIRONMENT}" == "PROD" ]; then
cat >> "${FULL_DIR}/${CONTAINER_NAME}.yml" << EOL

secrets:
  # Production
  ${CONTAINER_NAME}-msql-root:
    external: true
  ${CONTAINER_NAME}-wp-user:
    external: true
  ${CONTAINER_NAME}-wp-user-pass:
    external: true
EOL

else

cat >> "${FULL_DIR}/${CONTAINER_NAME}.yml" << EOL

secrets:
  # Development
  ${CONTAINER_NAME}-mysql-root-pass:
    file: ./data/secrets/mysql_root_password.txt
  ${CONTAINER_NAME}-wp-user:
    file: ./data/secrets/wordpress_user.txt
  ${CONTAINER_NAME}-wp-user-pass:
    file: ./data/secrets/wordpress-user-pass.txt
EOL
fi





cat > "${FULL_DIR}/env" << EOL
TRAEFIK_NETWORK=${TRAEFIK_NETWORK}
CONTAINER_NAME=${CONTAINER_NAME}
NGINX_HOST=${DOMAIN}
NGINX_PORT=80
EOL