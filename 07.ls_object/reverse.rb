# frozen_string_literal: true

class Reverse
  def initialize(filenames, reverse: false)
    @filenames = filenames
    @reverse = reverse
  end

  def reverse_filenames
    @reverse ? @filenames.reverse : @filenames
  end
end
