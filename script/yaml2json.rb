#!/usr/bin/env ruby

# yaml2json.rb

require 'yaml'
require 'json'

x = YAML.load($stdin.read)
x.delete('_ANCHORS')
puts JSON.pretty_generate(x)
