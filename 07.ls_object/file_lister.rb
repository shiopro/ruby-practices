# frozen_string_literal: true

class FileLister
  def initialize(path: '.', show_all: false)
    @path = path
    @show_all = show_all
  end

  def directory_contents
    filenames = Dir.entries(@path)
    filenames.reject! { |file| file.start_with?('.') } unless @show_all
    filenames.sort
  end

  def display_in_columns(files, max_columns = 3)
    max_length = files.map(&:length).max || 0
    column_width = max_length + 2

    rows = (files.size.to_f / max_columns).ceil
    rows.times do |row|
      line = Array.new(max_columns) do |col|
        index = row + col * rows
        (files[index] || '').ljust(column_width)
      end
      puts line.join
    end
  end
end
