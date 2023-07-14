#!/bin/bash

# This script is used to build the environment for the project
# It will check the branch and build the environment accordingly

gitBranchCheck() {
    branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
    if [[ $branch == main ]];
        then 
        echo "Env is production"
        docker build --build-arg isDev="false" --tag=vid-grenier-prod .
        docker compose --env-file ./config/.env.prod -f docker-compose.yml -f ./config/docker-compose.prod.yml up -d

    elif [[ $branch == staging ]];
        then
        echo "Env is staging"
        docker build --build-arg isDev="false" --tag=vid-grenier-staging .
        docker compose --env-file ./config/.env.staging -f docker-compose.yml -f ./config/docker-compose.staging.yml up -d
    
    else
        echo "Env is dev"
        docker build --build-arg isDev="true" --tag=vid-grenier-dev .
        docker compose --env-file .env -f docker-compose.yml -f docker-compose.dev.yml up -d
    fi
}

gitBranchCheck

