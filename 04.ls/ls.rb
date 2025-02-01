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
  modified_time = stat.mtime.strftime('%-m %-d %H:%M')
  modified_time = modified_time.split.map { |part| part.rjust(2, ' ') }.join(' ')
  {
    permissions: format_permissions(stat.mode, filename),
    links: stat.nlink,
    user: Etc.getpwuid(stat.uid).name,
    group: Etc.getgrgid(stat.gid).name,
    size: stat.size,
    modified_time: modified_time,
    name: filename
  }
end

def format_permissions(mode, filename)
  file_type = {
    'directory' => 'd',
    'file' => '-',
    'link' => 'l'
  }

  type = file_type[File.ftype(filename)]

  permissions = mode.to_s(8)[-3..].chars.map do |digit|
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
  type + permissions
end

def display_in_columns_long(files)
  total_blocks = files.sum { |file| File.stat(file).blocks }
  puts "total #{total_blocks}"

  details_list = files.map { |file| file_details(file) }
  max_width = {
    permissions: 10,
    links: details_list.map { |d| d[:links].to_s.length }.max,
    user: details_list.map { |d| d[:user].to_s.length }.max,
    group: details_list.map { |d| d[:group].length }.max,
    size: details_list.map { |d| d[:size].to_s.length }.max,
    modified_time: 12
  }

  details_list.each do |details|
    puts  "#{details[:permissions]}  #{details[:links].to_s.rjust(max_width[:links])} " \
          "#{details[:user].ljust(max_width[:user])}  #{details[:group].ljust(max_width[:group])}  " \
          "#{details[:size].to_s.rjust(max_width[:size])} #{details[:modified_time]} #{details[:name]}"
  end
end

def display_in_columns(files)
  max_length = files.map(&:length).max || 0
  column_width = max_length + 2

  rows = (files.size.to_f / max_length).ceil
  rows.times do |row|
    line = Array.new(max_length) do |col|
      index = row + col * rows
      (files[index] || '').ljust(column_width)
    end
    puts line.join
  end
end

files = directory_contents(show_all: options[:all])
sorted_files = reverse_filenames(files, reverse: options[:reverse])
options[:long] ? display_in_columns_long(sorted_files) : display_in_columns(sorted_files)
