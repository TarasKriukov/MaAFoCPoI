ALPHABET = 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя'

def vigenere_encrypt(text, key)
  encrypted_text = ''
  key_length = key.length
  text.each_char.with_index do |char, i|
    if ALPHABET.include?(char)
      key_char = key[i % key_length]
      shift = ALPHABET.index(key_char)
      new_char = ALPHABET[(ALPHABET.index(char) + shift) % ALPHABET.length]
      encrypted_text += new_char
    else
      encrypted_text += char
    end
  end
  encrypted_text
end

def vigenere_decrypt(encrypted_text, key)
  decrypted_text = ''
  key_length = key.length
  encrypted_text.each_char.with_index do |char, i|
    if ALPHABET.include?(char)
      key_char = key[i % key_length]
      shift = ALPHABET.index(key_char)
      new_char = ALPHABET[(ALPHABET.index(char) - shift + ALPHABET.length) % ALPHABET.length]
      decrypted_text += new_char
    else
      decrypted_text += char
    end
  end
  decrypted_text
end

# Тестові дані
text = 'програмнезабезпечення'
key = 'криптошрифт'

# Шифрування
encrypted_text = vigenere_encrypt(text, key)
puts "Зашифрований текст: #{encrypted_text}"

# Розшифрування
decrypted_text = vigenere_decrypt(encrypted_text, key)
puts "Розшифрований текст: #{decrypted_text}"
