# frozen_string_literal: true

require 'optparse'
require_relative 'file_lister'
require_relative 'reverse'
require_relative 'file_details'
require_relative 'long_format'

opt = OptionParser.new
options = {}

opt.on('-a', '--all') do
  options[:all] = true
end

opt.on('-r', '--reverse') do
  options[:reverse] = true
end

opt.on('-l', '--long') do
  options[:long] = true
end

opt.parse!(ARGV)

lister = FileLister.new(show_all: options[:all])
files = lister.directory_contents

reverser = Reverse.new(files, reverse: options[:reverse])
files = reverser.reverse_filenames

if options[:long]
  formatter = LongFormat.new(files)
  formatter.display_in_columns_long
else
  lister.display_in_columns(files)
end
