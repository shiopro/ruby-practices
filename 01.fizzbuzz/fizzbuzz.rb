#!/usr/bin/env ruby
(1..20).each do |n|
  case
  when n % 3 == 0 && n % 5 == 0
    puts "FizzBuzz"
  when n % 5 == 0
    puts "Buzz"
  when n % 3 == 0
    puts "Fizz"
  else
    puts n
  end
end
