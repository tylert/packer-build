#!/usr/bin/env python

# json2json.py

from __future__ import print_function

import sys
import json


def main():
    print(json.dumps(json.load(sys.stdin), sort_keys=True,
          indent=2, separators=(',', ': ')))


if __name__ == '__main__':
    main()
