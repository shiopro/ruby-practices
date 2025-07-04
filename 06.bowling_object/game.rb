# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(frames)
    @frames = frames
  end

  def bonus_score_except_last_frame(frame, next_frame, next_next_frame)
    if frame.strike?
      if next_frame&.strike?
        10 + (next_frame ? next_next_frame.first_shot.score : 0)
      else
        next_frame.first_shot.score + next_frame.second_shot.score
      end
    elsif frame.spare?
      next_frame.first_shot.score
    else
      0
    end
  end

  def total_score
    point = 0
    @frames.each_with_index do |frame, index|
      point += frame.score
      next if index >= 9

      next_frame = @frames[index + 1]
      next_next_frame = @frames[index + 2]
      bonus = bonus_score_except_last_frame(frame, next_frame, next_next_frame)
      point += bonus
    end
    point
  end
end
