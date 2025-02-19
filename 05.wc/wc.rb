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

# 標準入力またはコマンドライン引数から読み込めるようにする
def main(options)
  totals = { lines: 0, words: 0, bytes: 0 }
  if ARGV.empty?
    text = $stdin.read
    process_text(text, options, totals)
  else
    ARGV.each do |filename|
      text = File.read(filename)
      process_text(text, options, totals, filename)
    end

    total_counts(options, totals) if ARGV.size > 1
  end
end

# テキスト情報を処理して結果を取得
def process_text(text, options, totals, filename = nil)
  counts = {
    lines: text.lines.count,
    words: text.lines.sum { |line| line.split(/\s+/).reject(&:empty?).count },
    bytes: text.bytesize
  }

  # 合計用のカウントを加算
  totals[:lines] += counts[:lines]
  totals[:words] += counts[:words]
  totals[:bytes] += counts[:bytes]

  results = options.keys.map { |key| counts[key].to_s.rjust(7) if options[key] }
  results << filename if filename
  puts results.join(' ')
end

# 合計値の表示
def total_counts(options, totals)
  total_result = options.keys.map { |key| totals[key].to_s.rjust(7) if options[key] }
  total_result << 'total'
  puts total_result.join(' ')
end

main(options)
