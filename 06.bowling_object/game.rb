# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(frames)
    @frames = frames
  end

  def total_score
    @frames.each_with_index.sum do |frame, index|
      point = frame.score

      if index < 9 && (frame.strike? || frame.spare?)
        next_frame = @frames[index + 1]
        next_next_frame = @frames[index + 2]
        bonus = frame.bonus_score_except_last_frame(frame, next_frame, next_next_frame)
        point += bonus
      end
      point
    end
  end
end
