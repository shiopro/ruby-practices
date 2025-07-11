#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

scores = ARGV[0].split(',')
shots = scores.flat_map do |s|
  s == 'X' ? [10] : [s.to_i]
end

def build_frames(shots)
  i = 0
  frames = Array.new(9) do
    if shots[i] == 10
      frame = Frame.new(10, 0)
      i += 1
    else
      frame = Frame.new(shots[i], shots[i + 1])
      i += 2
    end
    frame
  end

  frames << Frame.new(shots[i], shots[i + 1], shots[i + 2])
  frames
end

frames = build_frames(shots)
game = Game.new(frames)
puts game.total_score
