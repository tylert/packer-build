#!/usr/bin/env python

# yaml2json.py

from __future__ import print_function

import sys
import json

import ruamel.yaml as yaml


if __name__ == '__main__':
    print(json.dumps(yaml.load(sys.stdin, Loader=yaml.Loader), sort_keys=True,
        indent=2, separators=(',', ': ')))
