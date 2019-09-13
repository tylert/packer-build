#!/usr/bin/env python3

# yaml2json.py

from __future__ import print_function

import sys
import json

import ruamel.yaml as yaml


def main():
    x = yaml.load(sys.stdin, Loader=yaml.Loader)
    del x['_ANCHORS']
    print(json.dumps(x, sort_keys=True,
          indent=2, separators=(',', ': ')))


if __name__ == '__main__':
    main()
