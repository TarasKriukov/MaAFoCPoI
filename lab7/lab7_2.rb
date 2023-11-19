def string_to_number(str)
  str.bytes.inject(0) { |num, byte| (num << 8) + byte }
end

def number_to_string(num)
  str = ''
  while num > 0
    str = (num & 0xFF).chr + str
    num >>= 8
  end
  str
end

def mod_exp(base, exponent, modulus)
  result = 1
  base = base % modulus

  while exponent.positive?
    result = (result * base) % modulus if exponent.odd?
    exponent >>= 1
    base = (base * base) % modulus
  end

  result
end

def miller_rabin_test(n, k)
  return false if n < 2
  return true if n == 2
  return false if n.even?

  r = 0
  d = n - 1
  while d.even?
    r += 1
    d >>= 1
  end

  k.times do
    a = 2 + rand(n - 4)
    x = mod_exp(a, d, n)

    next if x == 1 || x == n - 1

    (r - 1).times do
      x = mod_exp(x, 2, n)
      return false if x == 1
      break if x == n - 1
    end

    return false if x != n - 1
  end

  true
end

def generate_prime(bits)
  begin
    n = rand(2**(bits - 1)..2**bits)
  end until n.odd? && miller_rabin_test(n, 5)
  n
end

def extended_gcd(a, b)
  x0 = 1
  x1 = 0
  y0 = 0
  y1 = 1

  while b != 0
    q, r = a.divmod(b)
    a = b
    b = r
    x0, x1 = x1, x0 - q * x1
    y0, y1 = y1, y0 - q * y1
  end

  [x0, y0]
end

def mod_inverse(e, phi)
  x, = extended_gcd(e, phi)
  x %= phi
  x += phi if x < 0
  x
end

def generate_e(phi)
  e = rand(2..phi - 1)
  e += 1 until e.gcd(phi) == 1
  e
end

def encrypt(message, e, n)
  mod_exp(message, e, n)
end

def decrypt(ciphertext, d, n)
  mod_exp(ciphertext, d, n)
end

bits = 512
p = generate_prime(bits)
q = generate_prime(bits)

n = p * q
phi = (p - 1) * (q - 1)

e = generate_e(phi)
d = mod_inverse(e, phi)

puts "Відкритий ключ: (#{e}, #{n})"
puts "Закритий ключ: (#{d}, #{n})"

message_str = 'Hello World'
message_num = string_to_number(message_str)

raise 'Повідомлення занадто велике' if message_num >= n

ciphertext = encrypt(message_num, e, n)
puts "Зашифроване повідомлення: #{ciphertext}"

decrypted_num = decrypt(ciphertext, d, n)
decrypted_str = number_to_string(decrypted_num)
puts "Розшифроване повідомлення: #{decrypted_str}"
