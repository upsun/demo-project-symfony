#!/usr/bin/env bash

. scripts/variables.sh

HOME=$(pwd)
cd $PROJECT_NAME

cp $HOME/files/Controller/MainController.php src/Controller/MainController.php
mkdir templates/main
cp $HOME/files/templates/main/homepage.html.twig templates/main/homepage.html.twig
cp $HOME/files/assets/app.css assets/styles/app.css
symfony console asset-map:compile

git add assets/styles/app.css src/Controller/MainController.php templates/main/homepage.html.twig && git commit -m "adding styled homepage with speaker list"
# symfony deploy
# symfony ssh -- php bin/console doctrine:fixture:load -e dev
# symfony server:start -d


# Then test
#   - cd upsun_symfony_demo
#   - symfony server:start -d