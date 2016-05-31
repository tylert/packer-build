#!/usr/bin/env ruby

require 'yaml'
require 'json'

puts JSON.pretty_generate(YAML.load($stdin.read))
