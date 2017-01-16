#!/usr/bin/env python

import sys
import json

import ruamel.yaml as yaml


print(json.dumps(yaml.load(sys.stdin), sort_keys=True, indent=4,
    separators=(',', ': ')))
