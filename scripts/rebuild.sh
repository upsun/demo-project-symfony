#!/usr/bin/env bash

./scripts/clean.sh

./scripts/setup.sh

./scripts/handle-prod-data.sh 

./scripts/first_frontend.sh

./scripts/final_frontend.sh
