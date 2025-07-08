#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

scores = ARGV[0].split(',')
shots = scores.flat_map do |s|
  s == 'X' ? [10, 0] : s.to_i
end

frames = []
shots.each_slice(2) do |first_mark, second_mark|
  frames << Frame.new(first_mark, second_mark)
end

game = Game.new(frames)
puts game.total_score
