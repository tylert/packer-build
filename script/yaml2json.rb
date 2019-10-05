#!/usr/bin/env ruby

# yaml2json.rb

require 'yaml'
require 'json'

x = YAML.load($stdin.read)
x.delete('_anchors')
puts JSON.pretty_generate(x)
