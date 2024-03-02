#!/bin/bash

set -x

cd /srv/analysis/gpc-analysis-extension

npm install -g pretty-js
npm install -g rimraf
npm run build

# add the browser specific settings to the JSON file
cat << EXTRALINES | sed -i '/"incognito": "spanning"/r /dev/stdin' dist/firefox/manifest.json
, "browser_specific_settings": {
    "gecko": {
      "id": "{daf44bf7-a45e-4450-979c-91cf07434c3d}"
    }
  }
EXTRALINES

pretty-js --in-place dist/firefox/manifest.json
cat dist/firefox/manifest.json

ls dist/firefox
