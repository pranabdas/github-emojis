#!/bin/bash
if [ -d "assets" ]; then
  rm -rf assets
fi
mkdir -p assets/{png,unicode}

wget https://api.github.com/emojis -O _data.json

python3 <<EOF
import json

fid = open('_data.json')
data = json.load(fid)
fid.close()

fid = open('_urls', 'w')
for key, value in data.items():
    fid.write(f"wget {value} -O assets/png/{key}.png\n")
    unicode = value.split("/")[-1].split("?")[0]
    fid.write(f"cp assets/png/{key}.png assets/unicode/{unicode}\n")
fid.close()
EOF

bash _urls
rm _data.json _urls
