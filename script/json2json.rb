#!/usr/bin/env ruby

# json2json.rb

require 'json'

puts JSON.pretty_generate(JSON.parse($stdin.read))
