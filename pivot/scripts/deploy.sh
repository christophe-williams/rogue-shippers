#!/bin/bash

cnf ?= .env
include $(cnf)

function usage
{
  echo "usage: ./deploy [--region] reg"
}

while [ "$1" != "" ]; do
    case $1 in
        -r | --region ) shift
                             region=$1
                             ;;
        * )
            if [[ $region ]]; then
              echo "Given unrecognized parameter $1"
              usage
              exit 1
            else
              region=$1
            fi
    esac
    shift
done

if [[ $region ]]; then
  echo "region set to $region"
else
  region=$AWS_CLI_REGION
  echo "region defaulting to $region"
fi

DOCKER_REPO="$AWS_ACCOUNT.dkr.ecr.$AWS_CLI_REGION.amazonaws.com"

make repo-login

docker build --tag "$DOCKER_REPO:latest"

docker container run -p 8501:8501 --log-driver=awslogs --log-opt awslogs-group="/rogue-shippers/pivot/$region" -d "$DOCKER_REPO/$APP_NAME:latest"


