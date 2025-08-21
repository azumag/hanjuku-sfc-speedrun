#!/usr/bin/env ruby

require 'csv'

# ファイルパス
csv_path = File.join(File.dirname(__FILE__), '..', 'data', 'char.csv')
md_path = File.join(File.dirname(__FILE__), '..', 'data', 'char.md')

# CSVファイルを読み込み
data = []
headers = nil

CSV.foreach(csv_path, headers: false, encoding: 'UTF-8') do |row|
  if headers.nil?
    headers = row
  else
    data << row
  end
end

# Markdownテーブルの生成
markdown_content = []
markdown_content << "# キャラクター一覧"
markdown_content << ""

# ヘッダー行の作成
markdown_content << "| " + headers.join(" | ") + " |"
markdown_content << "|" + headers.map { "-" * 6 }.join("|") + "|"

# データ行の作成
data.each do |row|
  # nilや空文字を"-"に置換
  formatted_row = row.map { |cell| cell.nil? || cell.empty? ? "-" : cell }
  markdown_content << "| " + formatted_row.join(" | ") + " |"
end

# ファイルに書き込み
File.write(md_path, markdown_content.join("\n") + "\n")

puts "char.md has been created/updated successfully!"
puts "Total characters: #{data.size}"
puts "Columns: #{headers.join(', ')}"