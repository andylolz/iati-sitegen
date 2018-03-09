from lxml import etree as ET
import os, json
import sys

def mapping_to_json(mappings):
    for mapping in mappings.getroot().xpath('//mapping'):
        out = {
            'path': mapping.find('path').text,
            'codelist': mapping.find('codelist').attrib['ref']
        }
        if mapping.find('condition') is not None:
            out['condition'] = mapping.find('condition').text
        yield out

mappings = ET.parse(sys.argv[1])
json.dump(list(mapping_to_json(mappings)), sys.stdout)

