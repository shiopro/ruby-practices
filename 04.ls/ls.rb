#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
opt.parse!(ARGV)

def get_directory_contents(directory)
  Dir.children(directory).sort
end
