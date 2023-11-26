require 'openssl'

def powmod(a, b, c)
  a.to_bn.mod_exp(b, c).to_i
end

def prime?(n, k = 10)
  return false if n < 2
  return true if n == 2
  return false if n.even?

  d = n - 1
  r = 0
  while d.even?
    d /= 2
    r += 1
  end

  k.times do
    a = 2 + rand(n - 4)
    x = powmod(a, d, n)
    next if x == 1 || x == n - 1

    (r - 1).times do
      x = powmod(x, 2, n)
      return false if x == 1
      break if x == n - 1
    end

    return false if x != n - 1
  end

  true
end

def generate_large_prime(bits)
  begin
    n = OpenSSL::BN.rand(bits, -1, false).to_i
    n |= (1 << bits - 1) | 1
  end until prime?(n)
  n
end

def find_primitive_root(p)
  phi = p - 1
  factors = prime_factors(phi)
  (2..phi).each do |g|
    flag = true
    factors.each do |factor|
      if powmod(g, phi / factor, p) == 1
        flag = false
        break
      end
    end
    return g if flag
  end
end

def prime_factors(n)
  factors = []
  d = 2
  while d * d <= n
    while (n % d).zero?
      factors << d unless factors.include?(d)
      n /= d
    end
    d += 1
  end
  factors << n if n > 1
  factors
end

def generate_keys(bits)
  p = generate_large_prime(bits)
  g = find_primitive_root(p)
  x = rand(2...p - 1)
  y = powmod(g, x, p)
  { public_key: [p, g, y], private_key: x }
end

def encrypt(public_key, message)
  p, g, y = public_key
  k = rand(2...p - 1)
  a = powmod(g, k, p)
  b = (message * powmod(y, k, p)) % p
  [a, b]
end

def decrypt(private_key, encrypted_message, p)
  a, b = encrypted_message
  s = powmod(a, private_key, p)
  (b * powmod(s, p - 2, p)) % p
end

# Приклад використання
# keys = generate_keys(64)
# puts "Публічний ключ: #{keys[:public_key]}"
# puts "Приватний ключ: #{keys[:private_key]}"
#
# message = 11
# puts "Початкове повідомлення: #{message}"
#
# encrypted_message = encrypt(keys[:public_key], message)
# puts "Зашифроване повідомлення: #{encrypted_message}"
#
# decrypted_message = decrypt(keys[:private_key], encrypted_message, keys[:public_key][0])
# puts "Розшифроване повідомлення: #{decrypted_message}"

def string_to_numbers(str)
  str.bytes
end

def numbers_to_string(numbers)
  numbers.pack('C*').force_encoding('utf-8')
end

def encrypt_string(public_key, text)
  numbers = string_to_numbers(text)
  numbers.map { |number| encrypt(public_key, number) }
end

def decrypt_string(private_key, encrypted_data, p)
  decrypted_numbers = encrypted_data.map { |data| decrypt(private_key, data, p) }
  numbers_to_string(decrypted_numbers)
end

keys = generate_keys(64)
puts "Публічний ключ: #{keys[:public_key]}"
puts "Приватний ключ: #{keys[:private_key]}"

message = 'Hello World!'
puts "Початкове повідомлення: #{message}"

encrypted_message = encrypt_string(keys[:public_key], message)
puts "Зашифроване повідомлення: #{encrypted_message}"

decrypted_message = decrypt_string(keys[:private_key], encrypted_message, keys[:public_key][0])
puts "Розшифроване повідомлення: #{decrypted_message}"
