#!/usr/bin/env python3

# yaml2json.py

from __future__ import print_function

import sys
import json

import ruamel.yaml as yaml


def main():
    print(json.dumps(yaml.load(sys.stdin, Loader=yaml.Loader), sort_keys=True,
          indent=2, separators=(',', ': ')))


if __name__ == '__main__':
    main()
