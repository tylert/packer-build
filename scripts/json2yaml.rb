#!/usr/bin/env ruby

# json2yaml.rb

require 'json'
require 'yaml'

puts YAML.dump(JSON.parse($stdin.read))
