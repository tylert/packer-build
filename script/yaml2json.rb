#!/usr/bin/env ruby

# yaml2json.rb

require 'yaml'
require 'json'

puts JSON.pretty_generate(YAML.load($stdin.read))
