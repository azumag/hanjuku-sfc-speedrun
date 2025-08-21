#!/usr/bin/env ruby

require 'csv'

# 対象キャラクターの優先順位
PRIORITY_CHARS = ['しゅじんこう', 'ゼウス', 'ココット', 'ヴィーナス']

# CSVファイルの読み込み
csv_path = File.join(File.dirname(__FILE__), '..', 'data', 'egg-drop-combinations.csv')
output_path = File.join(File.dirname(__FILE__), '..', 'data', 'egg-drop-table.md')

# データを格納する配列
data_by_char = {}
all_chars = []

# CSVファイルを読み込み
CSV.foreach(csv_path, headers: false) do |row|
  next if row[0] == 'ID1' # ヘッダー行をスキップ
  
  char1 = row[1]
  char2 = row[2]
  hp1 = row[3]
  hp2 = row[4]
  total = row[5]
  remainder = row[6].to_i
  
  # すべてのキャラクターを処理
  data_by_char[char1] ||= []
  data_by_char[char1] << {
    partner: char2,
    hp1: hp1,
    hp2: hp2,
    total: total,
    remainder: remainder
  }
  
  # キャラクターリストに追加（重複を避ける）
  all_chars << char1 unless all_chars.include?(char1)
end

# 各キャラクターのデータを余りで降順ソート
data_by_char.each do |char, entries|
  entries.sort_by! { |e| -e[:remainder] }
end

# Markdownテーブルの生成
markdown_content = []

# ヘッダー
markdown_content << "# 卵落としテーブル"
markdown_content << ""
markdown_content << "## 優先キャラクター"

# 優先キャラクターを先に出力
PRIORITY_CHARS.each do |char|
  next unless data_by_char[char]
  
  markdown_content << ""
  markdown_content << "### #{char}"
  markdown_content << ""
  markdown_content << "| 相手 | #{char}HP | 相手HP | HP合計 | 余り |"
  markdown_content << "|------|-----------|--------|--------|------|"
  
  data_by_char[char].each do |entry|
    markdown_content << "| #{entry[:partner]} | #{entry[:hp1]} | #{entry[:hp2]} | #{entry[:total]} | #{entry[:remainder]} |"
  end
end

# その他のキャラクター
other_chars = all_chars - PRIORITY_CHARS
if other_chars.any?
  markdown_content << ""
  markdown_content << "## その他のキャラクター"
  
  # その他のキャラクターをアルファベット順または出現順でソート
  other_chars.sort.each do |char|
    next unless data_by_char[char]
    
    markdown_content << ""
    markdown_content << "### #{char}"
    markdown_content << ""
    markdown_content << "| 相手 | #{char}HP | 相手HP | HP合計 | 余り |"
    markdown_content << "|------|-----------|--------|--------|------|"
    
    data_by_char[char].each do |entry|
      markdown_content << "| #{entry[:partner]} | #{entry[:hp1]} | #{entry[:hp2]} | #{entry[:total]} | #{entry[:remainder]} |"
    end
  end
end

# ファイルに書き込み
File.write(output_path, markdown_content.join("\n") + "\n")

puts "egg-drop-table.md has been created/updated successfully!"
puts "Processed priority characters: #{PRIORITY_CHARS.join(', ')}"
puts "Total characters processed: #{data_by_char.keys.size}"
puts "Priority characters:"
PRIORITY_CHARS.each do |char|
  if data_by_char[char]
    puts "  #{char}: #{data_by_char[char].size} entries"
  end
end
puts "Other characters: #{other_chars.size}"