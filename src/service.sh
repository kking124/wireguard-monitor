#!/bin/bash
# service.sh
# author: https://github.com/kking124
# copyright: 2021
# license: MIT

#default to docker as the service
if [ -z "${SVC_HOST}" ]
then
  SVC_HOST="docker"
fi

#default to wireguard as the container name
if [ -z "${CONTAINER}" ]
then
  CONTAINER="wireguard"
fi

#restart a local docker container
if [[ "${SVC_HOST}" == "docker" ]]
then
  echo "trying to restart docker container ${CONTAINER}"
  docker restart "${CONTAINER}"
  exit 0;
fi

echo "'${SVC_HOST}' is not a valid SVC_HOST. Exiting with error."
exit 1
#TODO: add k8s, fargate, ecs, eks, etc.