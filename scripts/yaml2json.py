#!/usr/bin/env python

from __future__ import print_function

import sys
import json

import ruamel.yaml as yaml


print(json.dumps(yaml.load(sys.stdin), sort_keys=True, indent=4,
    separators=(',', ': ')))
