#!/usr/bin/env bash

. scripts/variables.sh

############################################################################################################
# A. Add bundles.
############################################################################################################
HOME=$(pwd)
cd $PROJECT_NAME

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
cat compose.yaml | sed 's/!/"!/' > compose.tmp.yaml
# Two '!' characters, so run twice.
cat compose.tmp.yaml | sed 's/!/!"/2' > compose.yaml
rm compose.tmp.yaml
git add compose.yaml && git commit -m "Update docker compose configuration."

docker compose up -d
DB_PUBLISHED_PORT=$(docker compose ps --format json | jq -r '.[] | select(.Service=="database") | .Publishers[0].PublishedPort')
printf "    
DATABASE_PORT=$DB_PUBLISHED_PORT
DATABASE_URL=\"postgresql://app:!ChangeMe!@127.0.0.1:$DATABASE_PORT/app?serverVersion=16&charset=utf8\"
" >> .env.dev


# Updated the DATABASE_URL="postgresql://app:!ChangeMe!@127.0.0.1:57133/app?serverVersion=16&charset=utf8" PORT
#   with what is shown in `docker ps`
# symfony console doctrine:migrations:diff
rsync -avzh $HOME/files/migrations .
git add migrations && git commit -m "Add migration for Speaker entity."

symfony console doctrine:migrations:migrate -n

cp $HOME/files/DataFixtures/AppFixtures.php src/DataFixtures/AppFixtures.php
symfony console doctrine:fixture:load -n

git add src/DataFixtures/AppFixtures.php && git commit -m "adding fixtures for speakers"

rm -rf $HOME/.composer
rm -rf $HOME/.symfony5
rm -rf $HOME/Library
rm -rf $HOME/.docker
