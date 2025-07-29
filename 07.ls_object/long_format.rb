# frozen_string_literal: true

class LongFormat
  def initialize(files)
    @files = files
  end

  def display
    total_blocks = @files.sum { |file| File.stat(file).blocks }
    puts "total #{total_blocks}"

    details_list = @files.map { |file| FileDetails.new(file).details }
    max_width = {
      permissions: 10,
      links: details_list.map { |d| d[:links].to_s.length }.max,
      user: details_list.map { |d| d[:user].to_s.length }.max,
      group: details_list.map { |d| d[:group].length }.max,
      size: details_list.map { |d| d[:size].to_s.length }.max,
      modified_time: 12
    }

    details_list.each do |details|
      puts  "#{details[:permissions]}  #{details[:links].to_s.rjust(max_width[:links])} " \
            "#{details[:user].ljust(max_width[:user])}  #{details[:group].ljust(max_width[:group])}  " \
            "#{details[:size].to_s.rjust(max_width[:size])} #{details[:modified_time]} #{details[:name]}"
    end
  end
end
