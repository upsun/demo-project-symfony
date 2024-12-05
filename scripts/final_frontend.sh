#!/usr/bin/env bash

. scripts/variables.sh

HOME=$(pwd)
cd $PROJECT_NAME

cp $HOME/files/Controller/SpeakerController.php src/Controller/SpeakerController.php
cp $HOME/files/Repository/SpeakerRepository2.php src/Repository/SpeakerRepository.php
git add src/Controller/SpeakerController.php src/Repository/SpeakerRepository.php && git commit -m "adding REST endpoint (Json) for speaker list and podium"

npx --yes create-next-app@latest $FRONTEND_NAME --yes --js 
cd $FRONTEND_NAME && npm install bootstrap
cd $HOME/$PROJECT_NAME

cp $HOME/files/client/page.js $FRONTEND_NAME/app/page.js
cp $HOME/files/client/page.css $FRONTEND_NAME/app/page.css
# cp $HOME/files/client/page.module.css $FRONTEND_NAME/app/page.module.css
cp $HOME/files/client/favicon.ico $FRONTEND_NAME/app/favicon.ico
mkdir $FRONTEND_NAME/app/component
cp $HOME/files/client/podium.js $FRONTEND_NAME/app/component/podium.js
cp $HOME/files/client/layout.js $FRONTEND_NAME/app/layout.js

git add . && git commit -m "Move over frontend files."
# todo - update .upsun/config.yaml with frontend config.

symfony server:start -d
cd $FRONTEND_NAME 
npm run dev
