# frozen_string_literal: true

require 'optparse'
require_relative 'file_lister'
require_relative 'column_formatter'
require_relative 'file_detail'
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

lister = FileLister.new(show_all: options[:all], reverse: options[:reverse])
files = lister.files

formatter = options[:long] ? LongFormatter.new(files) : ColumnFormatter.new(files)
formatter.display
