#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
options = {}
opt.on('-a', '--all') do
  options[:all] = true
end

opt.parse!(ARGV)

def directory_contents(show_all: false)
  if show_all
    Dir.entries('.').sort
  else
    Dir.entries('.').reject { |file| file.start_with?('.') }.sort
  end
end

def display_in_columns(files, max_columns = 3)
  max_length = files.map(&:length).max || 0
  column_width = max_length + 2

  rows = (files.size.to_f / max_columns).ceil
  rows.times do |row|
    line = Array.new(max_columns) do |col|
      index = row + col * rows
      (files[index] || '').ljust(column_width)
    end
    puts line.join
  end
end

files = directory_contents(show_all: options[:all])
display_in_columns(files)
