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

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, index|
  if index < 9
    # ストライクの場合
    if frame[0] == 10
      point += 10
      next_frame = frames[index + 1]
      next_next_frame = frames[index + 2]
      if next_frame[0] == 10
        point += 10
        point += next_next_frame[0] = 10 || next_next_frame[0].to_i
      else
        point += next_frame[0].to_i + next_frame[1].to_i
      end
    # スペアの場合
    elsif frame.sum == 10
      point += 10 + frames[index + 1][0]
    else
      point += frame.sum
    end
  # 最終フレーム
  else
    point += frame.sum
  end
end
puts point
