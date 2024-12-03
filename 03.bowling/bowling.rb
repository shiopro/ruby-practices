#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

STRIKE_POINTS = 10

def bonus_score_except_last_frame(frame, next_frame, next_next_frame)
  if frame[0] == 10
    if next_frame[0] == 10
      STRIKE_POINTS + next_next_frame[0].to_i
    else
      next_frame[0].to_i + next_frame[1].to_i
    end
  elsif frame.sum == 10
    next_frame[0].to_i
  else
    0
  end
end

def total_score(frames)
  point = 0
  frames.each_with_index do |frame, index|
    score = frame.sum
    point += score
    next if index >= 9

    next_frame = frames[index + 1]
    next_next_frame = frames[index + 2]
    bonus = bonus_score_except_last_frame(frame, next_frame, next_next_frame)
    point += bonus
  end
  point
end

puts total_score(frames)
