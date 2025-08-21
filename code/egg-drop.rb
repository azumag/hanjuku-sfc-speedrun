# すべてのキャラクタの組み合わせ（２つに限定）において
# HPをお互い合計して16で割った余りが7以下になる組み合わせを
# 網羅的にCSVで出力する
# ただし、相手がたまごを持っていない組み合わせは除外する
require 'csv'

# CSVファイルを読み込む
characters = []
CSV.foreach('./data/char.csv', headers: true) do |row|
  characters << {
    id: row['ID'].to_i,
    name: row['名前'],
    form: row['姿'],
    hp: row['HP'].to_i,
    egg: row['エッグ']
  }
end

# エッグを持っているキャラクターのみをフィルタ
characters_with_egg = characters.select { |char| char[:egg] && char[:egg] != '－' }

# 結果を格納する配列
results = []

# すべての組み合わせをチェック
characters.each do |char1|
  characters_with_egg.each do |char2|
    # 同じキャラクター同士の組み合わせはスキップ
    next if char1[:id] == char2[:id]
    
    # HP合計と余りを計算
    hp_sum = char1[:hp] + char2[:hp]
    remainder = hp_sum % 16
    
    # 余りが7以下の場合のみ結果に追加
    if remainder <= 7
      results << [
        char1[:id],
        char1[:name],
        char2[:name],
        char1[:hp],
        char2[:hp],
        hp_sum,
        remainder
      ]
    end
  end
end

# CSVファイルに出力
CSV.open('combinations.csv', 'w') do |csv|
  # ヘッダーを書き込む
  csv << ['ID1', '名前1', '名前2', 'HP1', 'HP2', 'HP合計', '余り']
  
  # 結果を書き込む
  results.each do |result|
    csv << result
  end
end

# コンソールにも出力
results.each do |result|
  puts result.join(',')
end