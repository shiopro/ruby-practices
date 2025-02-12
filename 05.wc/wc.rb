#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
options = {}

opt.on('-l', '--lines') do
  options[:lines] = true
end

opt.on('-w', '--words') do
  options[:words] = true
end

opt.on('-c', '--bytes') do
  options[:bytes] = true
end

opt.parse!(ARGV)

# オプション指定がない場合、すべてのオプションをtrueに設定
options = { lines: true, words: true, bytes: true } if options.empty?

# 行数をカウントして取得
def count_lines(text)
  text.lines.count
end

# 単語数を取得
def count_words(text)
  text.split(/\s+/).size
end

# バイト数を取得
def count_bytes(text)
  text.bytesize
end

# テキスト情報を処理して結果を取得
def process_text(text, options, filename = nil)
  counts = {
    lines: count_lines(text),
    words: count_words(text),
    bytes: count_bytes(text)
  }

  results = options.keys.map { |key| counts[key].to_s.rjust(7) if options[key] }
  results << filename if filename
  puts results.join(' ')
end

# 標準入力またはコマンドライン引数から読み込めるようにする
if ARGV.empty?
  text = $stdin.read
  process_text(text, options)
else
  ARGV.each do |filename|
    text = File.read(filename)
    process_text(text, options, filename)
  end
end
