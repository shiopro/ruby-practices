# frozen_string_literal: true

class ColumnFormatter
  def initialize(files, max_columns = 3)
    @files = files
    @max_columns = max_columns
  end

  def output_columns
    max_length = @files.map(&:length).max || 0
    column_width = max_length + 2

    rows = (@files.size.to_f / @max_columns).ceil
    rows.times do |row|
      line = Array.new(@max_columns) do |col|
        index = row + col * rows
        (@files[index] || '').ljust(column_width)
      end
      puts line.join
    end
  end
end
