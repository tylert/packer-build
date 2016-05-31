#!/usr/bin/env ruby

require 'json'
require 'yaml'

puts YAML.dump(JSON.parse($stdin.read))
