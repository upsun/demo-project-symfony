#!/usr/bin/env bash

############################################################################################################
# Helper functions
############################################################################################################
. scripts/variables.sh

check_command_installed () {
    COMMAND=$1
    if ! [ -x "$(command -v $COMMAND)" ]; then
        echo "::error::'$COMMAND' is not installed and/or not executable. Please install it. Exiting." >&2
        exit 1
    else
        echo "::notice::'$COMMAND' is installed and executable. Success."
    fi
}


############################################################################################################
# A. Setting up.
############################################################################################################

# 1. Check CLIs are installed.
check_command_installed symfony
check_command_installed upsun
check_command_installed docker
check_command_installed jq
check_command_installed node
check_command_installed npx

# 2. Create a new demo skeleton project.
symfony new $PROJECT_NAME --php=$PHP_VERSION --upsun
cd $PROJECT_NAME

BASE_CONFIG=$(tail -n +12 ".upsun/config.yaml")
printf "    
applications:
    $BACKEND_NAME:
        source:
            root: \"/\"
$BASE_CONFIG

        relationships:
            database:

services:
    database:
        type: \"postgresql:$POSTGRES_VERSION\"

routes:
    \"https://$BACKEND_NAME.{all}/\": 
        type: upstream
        upstream: \"$BACKEND_NAME:http\"
        id: $BACKEND_NAME
    \"http://$BACKEND_NAME.{all}/\":
        type: redirect
        to: \"https://$BACKEND_NAME.{all}/\"
" > .upsun/config.yaml

git add . && git commit -m "Initialize Symfony skeleton"

# symfony upsun:create --org $PROJECT_ORG --title $PROJECT_NAME --region $PROJECT_REGION --default-branch $DEFAULT_BRANCH --set-remote -y
# symfony push -y
