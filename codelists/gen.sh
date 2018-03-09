#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_PATH=$SCRIPT_PATH/..
BUILD_PATH=$ROOT_PATH/_build
OUTPUT_PATH=$ROOT_PATH/_output

rm -rf $BUILD_PATH
rm -rf $OUTPUT_PATH
mkdir $BUILD_PATH
mkdir $OUTPUT_PATH

git clone -b $1 https://github.com/IATI/IATI-Codelists.git $BUILD_PATH/IATI-Codelists
git clone -b master https://github.com/IATI/IATI-Codelists-NonEmbedded.git $BUILD_PATH/IATI-Codelists-NonEmbedded

mkdir $BUILD_PATH/combined-xml
cp $BUILD_PATH/IATI-Codelists/xml/* $BUILD_PATH/combined-xml

rm -rf $OUTPUT_PATH
mkdir -p $OUTPUT_PATH/clv2/xml

if [ "${1:0:9}" == "version-1" ]; then
    for f in $BUILD_PATH/IATI-Codelists-NonEmbedded/xml/*; do
        python $SCRIPT_PATH/v3tov2.py $f > $BUILD_PATH/combined-xml/`basename $f`;
    done
    cp $BUILD_PATH/combined-xml/* $OUTPUT_PATH/clv2/xml
else
    cp $BUILD_PATH/IATI-Codelists-NonEmbedded/xml/* $BUILD_PATH/combined-xml
    mkdir -p $OUTPUT_PATH/clv3/xml
    cp $BUILD_PATH/combined-xml/* $OUTPUT_PATH/clv3/xml
    for f in $BUILD_PATH/combined-xml/*; do
        python $SCRIPT_PATH/v3tov2.py $f > $OUTPUT_PATH/clv2/xml/`basename $f`;
    done
fi

python $SCRIPT_PATH/gen.py $OUTPUT_PATH
python $SCRIPT_PATH/v2tov1.py $OUTPUT_PATH

python $SCRIPT_PATH/mappings_to_json.py $BUILD_PATH/IATI-Codelists/mapping.xml > $OUTPUT_PATH/clv1/mapping.json
python $SCRIPT_PATH/mappings_to_json.py $BUILD_PATH/IATI-Codelists/mapping.xml > $OUTPUT_PATH/clv2/mapping.json
cp $BUILD_PATH/IATI-Codelists/mapping.xml $OUTPUT_PATH/clv1/
cp $BUILD_PATH/IATI-Codelists/mapping.xml $OUTPUT_PATH/clv2/

if [ "${1:0:9}" != "version-1" ]; then
    cp $OUTPUT_PATH/clv2/mapping.{xml,json} $OUTPUT_PATH/clv3/
    cp -r $OUTPUT_PATH/clv2/{codelists.json,codelists.xml,csv,json} $OUTPUT_PATH/clv3/
fi
