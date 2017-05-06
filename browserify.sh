#!/bin/sh
node node_modules/browserify/bin/cmd.js -t ejsify clientside.js -o static/js/bundle.js
notify-send "new bundle ready"

