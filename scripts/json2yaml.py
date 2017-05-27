#!/usr/bin/env python

# json2yaml.py

from __future__ import print_function

import sys
import json

import ruamel.yaml as yaml


if __name__ == '__main__':
    print('---')
    print(yaml.dump(json.load(sys.stdin), Dumper=yaml.RoundTripDumper))
