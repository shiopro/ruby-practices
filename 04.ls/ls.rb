#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
opt.parse!(ARGV)

def directory_contents
  directory = '.'
  Dir.entries(directory).reject { |file| file.start_with?('.') }.sort
end

def display_in_columns(files, max_columns = 3)
  max_length = files.map(&:length).max || 0
  column_width = max_length + 2

  rows = (files.size.to_f / max_columns).ceil
  rows.times do |row|
    line = []
    max_columns.times do |col|
      index = row + col * rows
      line << (files[index] || '').ljust(column_width)
    end
    puts line.join
  end
end

files = directory_contents
display_in_columns(files)
