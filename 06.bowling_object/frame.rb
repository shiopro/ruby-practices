# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    [@first_shot, @second_shot, @third_shot].map(&:score).sum
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    [@first_shot, @second_shot].map(&:score).sum == 10 && !strike?
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
    first_score = next_frame.first_shot.score

    if next_frame.strike?
      next_shot = next_next_frame&.first_shot&.score || next_frame.second_shot.score || 0
      first_score + next_shot
    else
      first_score + next_frame.second_shot.score
    end
  end
end
