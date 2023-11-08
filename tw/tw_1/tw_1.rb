def gcd(a, b)
  while b != 0
    a, b = b, a % b
  end
  a
end

def multiplicative_inverse(a, m)
  return nil if gcd(a, m) != 1
  u1, u2, u3 = 1, 0, a
  v1, v2, v3 = 0, 1, m
  while v3 != 0
    q = u3 / v3
    v1, v2, v3, u1, u2, u3 = u1 - q * v1, u2 - q * v2, u3 - q * v3, v1, v2, v3
  end
  u1 % m
end

def affine_encrypt(text, a, s, n)
  result = ''
  text.each_char do |char|
    if char.match?(/[A-Za-z]/)
      x = char.downcase.ord - 'a'.ord
      enc = (a * x + s) % n
      result += (enc + 'a'.ord).chr
    else
      result += char
    end
  end
  result
end

def affine_decrypt(cipher, a, s, n)
  result = ''
  a_inv = multiplicative_inverse(a, n)
  raise 'Мультиплікативного зворотного для заданого "а" не існує.' if a_inv.nil?
  cipher.each_char do |char|
    if char.match?(/[A-Za-z]/)
      y = char.downcase.ord - 'a'.ord
      dec = (a_inv * (y - s)) % n
      result += (dec + 'a'.ord).chr
    else
      result += char
    end
  end
  result
end

a = 7
s = 2
n = 26

plain_text = "hello world"
cipher_text = affine_encrypt(plain_text, a, s, n)
puts "Зашифроване повідомлення: #{cipher_text}"

decrypted_text = affine_decrypt(cipher_text, a, s, n)
puts "Розшифроване повідомлення: #{decrypted_text}"

