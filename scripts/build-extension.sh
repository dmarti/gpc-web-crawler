#!/bin/bash

set -x

cd /srv/analysis/gpc-analysis-extension

npm install rimraf
npm run build

# add the browser specific settings to the JSON file (the comma on a
# line by itself is not pretty but validates)
cat << EXTRALINES | sed -i '/"incognito": "spanning"/r /dev/stdin' dist/firefox/manifest.json
,
"browser_specific_settings": {
    "gecko": {
      "id": "{daf44bf7-a45e-4450-979c-91cf07434c3d}"
    }
  }
EXTRALINES

cat dist/firefox/manifest.json


