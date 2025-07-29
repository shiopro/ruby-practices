# frozen_string_literal: true

require 'etc'

class FileDetail
  DIGIT = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  FILETYPE = {
    'directory' => 'd',
    'file' => '-',
    'link' => 'l'
  }.freeze

  def initialize(filename)
    @filename = filename
    @stat = File.stat(@filename)
  end

  def details
    {
      permissions: format_permissions,
      links: @stat.nlink,
      user: Etc.getpwuid(@stat.uid).name,
      group: Etc.getgrgid(@stat.gid).name,
      size: @stat.size,
      modified_time:,
      name: @filename
    }
  end

  def format_permissions
    type = FILETYPE[File.ftype(@filename)]

    permissions = @stat.mode.to_s(8)[-3..].chars.map { |digit| DIGIT[digit] }.join
    type + permissions
  end

  def modified_time
    time = @stat.mtime.strftime('%-m %-d %H:%M')
    time.split.map { |part| part.rjust(2, ' ') }.join(' ')
  end
end
