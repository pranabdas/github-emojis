#!/bin/bash
if [ -d "assets" ]; then
  rm -rf assets
fi
mkdir -p assets/{png,unicode}

curl -s https://api.github.com/emojis | jq -r 'to_entries[] | "\(.key)=\(.value)"' | while IFS='=' read -r name url; do
  path=${url%%\?*}
  unicode=${path##*/}

  echo "Downloading ${name} ($url)"
  curl -so assets/png/${name}.png $url
  if [[ $(file -b --mime-type assets/png/${name}.png) != "image/png" ]]; then
    echo "Warning!!! assets/png/${name}.png IS NOT PNG IMAGE. Restoring previous version..."
    git restore assets/png/${name}.png
  fi
  cp assets/png/${name}.png assets/unicode/$unicode
done
