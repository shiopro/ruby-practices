# frozen_string_literal: true

class FileLister
  def initialize(path: '.', show_all: false, reverse: false)
    @path = path
    @show_all = show_all
    @reverse = reverse
  end

  def files
    filenames = Dir.entries(@path)
    filenames.reject! { |file| file.start_with?('.') } unless @show_all
    sorted = filenames.sort
    @reverse ? sorted.reverse : sorted
  end
end
