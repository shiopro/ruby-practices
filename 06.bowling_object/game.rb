# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(frames)
    @frames = frames
  end

  def bonus_score_except_last_frame(frame, next_frame, next_next_frame)
    return 0 unless next_frame
    return spare_bonus(next_frame) if frame.spare?
    return strike_bonus(next_frame, next_next_frame) if frame.strike?

    0
  end

  def spare_bonus(next_frame)
    next_frame.first_shot.score
  end

  def strike_bonus(next_frame, next_next_frame)
    if next_frame.strike?
      next_shot = next_next_frame&.first_shot&.score || next_frame.second_shot.score || 0
      10 + next_shot
    else
      next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def total_score
    point = 0
    @frames.each_with_index do |frame, index|
      point += frame.score
      next if index >= 9

      next_frame = @frames[index + 1]
      next_next_frame = @frames[index + 2]

      if next_frame && (frame.strike? || frame.spare?)
        bonus = bonus_score_except_last_frame(frame, next_frame, next_next_frame)
        point += bonus
      end
    end
    point
  end
end
