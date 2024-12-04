#!/usr/bin/env bash

. scripts/variables.sh

cp $HOME/files/Controller/MainController.php src/Controller/MainController.php
mkdir templates/main
cp $HOME/files/templates/main/homepage.html.twig templates/main/homepage.html.twig
cp $HOME/files/assets/app.css assets/style/app.css
symfony console asset-map:compile
