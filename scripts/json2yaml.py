#!/usr/bin/env python

from __future__ import print_function

import sys
import json

import ruamel.yaml as yaml


print(yaml.dump(json.load(sys.stdin), Dumper=yaml.RoundTripDumper))
