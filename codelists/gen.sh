#!/bin/bash

rm -rf combined-xml
if [ -d IATI-Codelists-NonEmbedded ]; then
    cd IATI-Codelists-NonEmbedded || exit 1
    git checkout master
    git pull origin master
    cd .. || exit 1
else
    git clone -b master https://github.com/IATI/IATI-Codelists-NonEmbedded.git
fi

mkdir combined-xml
cp xml/* combined-xml

rm -rf out
mkdir -p out/clv2/xml

if [ "${1:0:9}" == "version-1" ]; then
    for f in IATI-Codelists-NonEmbedded/xml/*; do
        python v3tov2.py $f > combined-xml/`basename $f`;
    done
    cp combined-xml/* out/clv2/xml
else
    cp IATI-Codelists-NonEmbedded/xml/* combined-xml
    mkdir -p out/clv3/xml
    cp combined-xml/* out/clv3/xml
    for f in combined-xml/*; do
        python v3tov2.py $f > out/clv2/xml/`basename $f`;
    done
fi

python gen.py
python v2tov1.py

python mappings_to_json.py
cp mapping.{xml,json} out/clv1/
cp mapping.{xml,json} out/clv2/

if [ "${1:0:9}" == "version-2" ]; then
    cp mapping.{xml,json} out/clv3/
    cp -r out/clv2/{codelists.json,codelists.xml,csv,json} out/clv3/
fi
