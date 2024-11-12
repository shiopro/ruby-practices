#!/usr/bin/env ruby

require "optparse"
require "date"

opt = OptionParser.new
options = {}
opt.on("-y, year", Integer) {|year| options[:year] = year}
opt.on("-m, month", Integer) {|month| options[:month] = month}
opt.parse!(ARGV)

year = options[:year] || Date.today.year
month = options[:month] || Date.today.month

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)
first_wday = first_day.wday

puts "     #{month}月 #{year}"
puts "日 月 火 水 木 金 土"

print "   " * first_wday

(first_day..last_day).each do |date|
  print date.day.to_s.rjust(2) + " "
  puts "\n" if date.wday == 6
end
