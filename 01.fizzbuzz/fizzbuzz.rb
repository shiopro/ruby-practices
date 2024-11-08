#!/usr/bin/env ruby
numbers = (1..20).to_a
numbers.each do |n|
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
