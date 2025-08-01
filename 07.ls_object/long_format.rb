# frozen_string_literal: true

class LongFormatter
  def initialize(files)
    @files = files
  end

  def display
    total_blocks = @files.sum { |file| File.stat(file).blocks }
    puts "total #{total_blocks}"

    details = @files.map { |file| FileDetail.new(file).to_hash }
    max_width = {
      permissions: 10,
      links: details.map { |d| d[:links].to_s.length }.max,
      user: details.map { |d| d[:user].to_s.length }.max,
      group: details.map { |d| d[:group].length }.max,
      size: details.map { |d| d[:size].to_s.length }.max,
      modified_time: 12
    }

    details.each do |detail|
      puts  "#{detail[:permissions]}  #{detail[:links].to_s.rjust(max_width[:links])} " \
            "#{detail[:user].ljust(max_width[:user])}  #{detail[:group].ljust(max_width[:group])}  " \
            "#{detail[:size].to_s.rjust(max_width[:size])} #{detail[:modified_time]} #{detail[:name]}"
    end
  end
end
