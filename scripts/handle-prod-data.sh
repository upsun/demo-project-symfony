#!/usr/bin/env bash

. scripts/variables.sh

############################################################################################################
# A. Add bundles.
############################################################################################################
HOME=$(pwd)
cd $PROJECT_NAME/$BACKEND_NAME

symfony composer require -n \
  doctrine/annotations \
  doctrine/doctrine-bundle \
  doctrine/doctrine-migrations-bundle \
  doctrine/orm nelmio/cors-bundle \
  symfony/doctrine-bridge \
  symfony/html-sanitizer \
  symfony/http-client \
  symfony/intl symfony/monolog-bundle \
  symfony/security-bundle \
  symfony/serializer \
  symfony/twig-bundle \
  symfony/asset-mapper \
  symfony/asset \
  symfony/twig-pack

symfony composer require --dev doctrine/doctrine-fixtures-bundle symfony/maker-bundle

git add . && git commit -m "adding required bundles: doctrine, twig, assets, ..."

############################################################################################################
# B. Create Speaker entity
############################################################################################################
# symfony console make:entity Speaker
cp $HOME/files/Entity/Speaker.php src/Entity/Speaker.php
cp $HOME/files/Repository/SpeakerRepository.php src/Repository/SpeakerRepository.php
git add . && git commit -m "Add Speaker entity"

############################################################################################################
# C. Create Migration files
############################################################################################################
# Removing characters that prevent docker-compose from running properly
#   See https://github.com/symfony/recipes/pull/1366.
sed -i -e 's/!//' compose.yaml
Two '!' charaters, so run twice.
sed -i -e 's/!//' compose.yaml

# docker compose up -d
# dockr ps
# Updated the DATABASE_URL="postgresql://app:!ChangeMe!@127.0.0.1:57133/app?serverVersion=16&charset=utf8" PORT
#   with what is shown in `docker ps`
# symfony console doctrine:migrations:diff
cp $HOME/files/migrations/* migrations/*
git add migrations && git commit -m "Add migration for Speaker entity."

cp $HOME/files/DataFixtures/AppFixtures.php src/DataFixtures/AppFixtures.php
# symfony console doctrine:fixture:load
git add src/DataFixtures/AppFixtures.php && git commit -m "adding fixtures for speakers"