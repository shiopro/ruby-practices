#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

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

def directory_contents(show_all: false)
  filenames = Dir.entries('.')
  filenames.reject! { |file| file.start_with?('.') } unless show_all
  filenames.sort
end

def reverse_filenames(filenames, reverse: false)
  reverse ? filenames.reverse : filenames
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
sorted_files = reverse_filenames(files, reverse: options[:reverse])
display_in_columns(sorted_files)
