#!/usr/bin/env python

import sys
import json

import ruamel.yaml as yaml


print(yaml.dump(json.load(sys.stdin), Dumper=yaml.RoundTripDumper))
