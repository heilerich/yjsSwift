#!/bin/sh
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
npm i yjs@^13.0.0
npx browserify -r yjs -s yjs -o yjs.js
rm -r node_modules package-lock.json
mv yjs.js $SCRIPTPATH/../Sources/yjsSwift/Resources
