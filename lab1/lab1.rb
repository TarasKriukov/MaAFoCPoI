def double_key_encrypt(text, row_key, col_key)
  rows = row_key.length
  cols = col_key.length
  matrix = Array.new(rows) { Array.new(cols, ' ') }
  index = 0

  rows.times do |i|
    cols.times do |j|
      matrix[i][j] = text[index] if index < text.length
      index += 1
    end
  end

  sorted_matrix = matrix.sort_by.with_index { |_, i| row_key[i] }

  encrypted_text = ''
  col_key.chars.sort.each do |ch|
    col_index = col_key.index(ch)
    rows.times { |i| encrypted_text += sorted_matrix[i][col_index] }
  end

  encrypted_text
end

def double_key_decrypt(encrypted_text, row_key, col_key)
  rows = row_key.length
  cols = col_key.length
  matrix = Array.new(rows) { Array.new(cols, ' ') }
  index = 0

  col_key.chars.sort.each do |ch|
    col_index = col_key.index(ch)
    rows.times do |i|
      matrix[i][col_index] = encrypted_text[index] if index < encrypted_text.length
      index += 1
    end
  end

  original_order = row_key.chars.map.with_index.sort.map { |_, i| i }
  sorted_matrix = matrix.sort_by.with_index { |_, i| original_order[i] }

  decrypted_text = ''
  rows.times do |i|
    cols.times { |j| decrypted_text += sorted_matrix[i][j] }
  end

  decrypted_text.rstrip
end

# Тестові дані
text = 'програмнезабезпечення'
row_key = 'шифр'
col_key = 'крипто'

# Шифрування
encrypted_text = double_key_encrypt(text, row_key, col_key)
puts "Зашифрований текст: #{encrypted_text}"

# Розшифрування
decrypted_text = double_key_decrypt(encrypted_text, row_key, col_key)
puts "Розшифрований текст: #{decrypted_text}"
