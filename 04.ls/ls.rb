#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

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

def file_details(filename)
  stat = File.stat(filename)
  {
    permissions: format_permissions(stat.mode),
    links: stat.nlink,
    user: Etc.getpwuid(stat.uid).name,
    group: Etc.getgrgid(stat.gid).name,
    size: stat.size,
    modified_time: stat.mtime.strftime('%m %d %H %M'),
    name: filename
  }
end

def format_permissions(mode)
  permissions = mode.to_s(8)[-3..].chars.map do |digit|
  types = { 'file' => '-', 'directory' => 'd' }
  type = types[File.ftype('.') || '-']
  {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }[digit]
  end.join
end

def display_in_columns(files, long: false)
  if long
    files.each do |file|
      details = file_details(file)
      puts "#{details[:permissions]} #{details[:links]} #{details[:user]} #{details[:group]} #{details[:size]} #{details[:modified_time]} #{details[:name]}"
    end
  else
    max_length = files.map(&:length).max || 0
    column_width = max_length + 2

    rows = (files.size.to_f / max_columns).ceil
    rows.times do |row|
      line = Array.new(max_columns) do |col|
        index = row + col * rows
        (files[index] || '').ljust(column_width)
      end
    end
    puts line.join
  end
end

files = directory_contents(show_all: options[:all])
sorted_files = reverse_filenames(files, reverse: options[:reverse])
display_in_columns(sorted_files, long: options[:long])
