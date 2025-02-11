#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
options = {}

opt.on('-l', '--lines') do
  options[:lines] = true
end

opt.on('-w', '--words') do
  options[:words] = true
end

opt.on('-c', '--bytes') do
  options[:bytes] = true
end

opt.parse!(ARGV)
