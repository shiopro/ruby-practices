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

# ストライクのスコア計算メソッド
def calculate_strike_score(frames, index)
  point = 10
  next_frame = frames[index + 1]
  next_next_frame = frames[index + 2]
  if next_frame[0] == 10
    point += 10
    point += if next_next_frame[0] == 10
               10
             else
               next_next_frame[0].to_i
             end
  else
    point += next_frame[0].to_i + next_frame[1].to_i
  end
  point
end

point = 0
frames.each_with_index do |frame, index|
  point += if index < 9
             # ストライクの場合
             if frame[0] == 10
               calculate_strike_score(frames, index)
             # スペアの場合
             elsif frame.sum == 10
               10 + frames[index + 1][0]
             else
               frame.sum
             end
           # 最終フレーム
           else
             frame.sum
           end
end
puts point
