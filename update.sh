#!/bin/bash
if [ -d "assets" ]; then
  rm -rf assets
fi
mkdir -p assets/png
mkdir assets/unicode

wget https://api.github.com/emojis -O _data.json

python3 <<EOF
import json

fid = open('_data.json')
data = json.load(fid)
fid.close()

fid = open('_urls', 'w')
for key, value in data.items():
    fid.write("wget {0} -O assets/png/{1}.png\n".format(value, key))
    unicode = value.split("/")[-1].split("?")[0]
    fid.write("cp assets/png/{0}.png assets/unicode/{1}\n".format(key, unicode))
fid.close()
EOF

bash _urls
rm _data.json _urls
