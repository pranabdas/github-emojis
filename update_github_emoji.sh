#!/bin/bash
if [ -d "assets" ]; then
  rm -rf assets
fi
mkdir -p assets/png
mkdir assets/unicode

wget https://api.github.com/emojis -O data.json

python3 <<EOF
import json

fid = open('data.json')
data = json.load(fid)
fid.close()

fid = open('wget_urls', 'w')
for key, value in data.items():
    fid.write("wget {0} -O assets/png/{1}.png\n".format(value, key))
    unicode = value.split("/")[-1].split("?")[0]
    fid.write("cp assets/png/{0}.png assets/unicode/{1}\n".format(key, unicode))
fid.close()

fid = open('README.md', 'w')
fid.write("# GitHub emoji assets\n\nThis repository contains the GitHub emoji assets in PNG format. Here are all the {0} emojis:\n\nName | Emoji\n---- | -----\n".format(len(data)))
for key in data.keys():
    fid.write('{0} | <img src="assets/png/{0}.png" alt="{0}" width=20/>\n'.format(key))
fid.close()
EOF

bash wget_urls
rm data.json wget_urls
