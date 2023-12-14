require 'openssl'

def prepare_message_for_sha1(message)
  bits = "#{message.unpack1('B*')}1#{'0' * ((448 - message.length * 8 - 1) % 512)}#{[message.length * 8].pack('Q>').unpack1('B*')}" # Rubocop: disable Layout/LineLength
  bits.scan(/.{512}/)
end

def left_rotate(value, shift)
  ((value << shift) | (value >> (32 - shift))) & 0xffffffff
end

def main_loop(a, b, c, d, e, w)
  80.times do |i|
    if i < 20
      f = (b & c) | (~b & d)
      k = 0x5A827999
    elsif i < 40
      f = b ^ c ^ d
      k = 0x6ED9EBA1
    elsif i < 60
      f = (b & c) | (b & d) | (c & d)
      k = 0x8F1BBCDC
    else
      f = b ^ c ^ d
      k = 0xCA62C1D6
    end

    temp = left_rotate(a, 5) + f + e + k + w[i]
    e = d
    d = c
    c = left_rotate(b, 30)
    b = a
    a = temp & 0xffffffff
  end

  [a, b, c, d, e]
end

def final_addition(h0, h1, h2, h3, h4, a, b, c, d, e)
  [(h0 + a) & 0xffffffff, (h1 + b) & 0xffffffff, (h2 + c) & 0xffffffff, (h3 + d) & 0xffffffff, (h4 + e) & 0xffffffff]
end

def sha1(message)
  h0 = 0x67452301
  h1 = 0xEFCDAB89
  h2 = 0x98BADCFE
  h3 = 0x10325476
  h4 = 0xC3D2E1F0

  prepare_message_for_sha1(message).each do |block|
    w = (0..15).map { |i| block[i * 32, 32].to_i(2) } + Array.new(64, 0)
    (16..79).each { |i| w[i] = left_rotate(w[i - 3] ^ w[i - 8] ^ w[i - 14] ^ w[i - 16], 1) }

    a = h0
    b = h1
    c = h2
    d = h3
    e = h4
    a, b, c, d, e = main_loop(a, b, c, d, e, w)
    h0, h1, h2, h3, h4 = final_addition(h0, h1, h2, h3, h4, a, b, c, d, e)
  end

  p format('%08x%08x%08x%08x%08x', h0, h1, h2, h3, h4)
end

def invmod(e, et)
  g, x, = extended_gcd(e, et)
  raise 'The inverse does not exist' if g != 1

  x % et
end

def extended_gcd(a, b)
  return [b, 0, 1] if (a % b).zero?

  g, x, y = extended_gcd(b, a % b)
  [g, y, x - y * (a / b)]
end

def pow_mod(base, exponent, mod)
  result = 1
  base %= mod
  while exponent.positive?
    result = (result * base) % mod if exponent.odd?
    exponent >>= 1
    base = (base * base) % mod
  end
  result
end

def is_prime?(n, k = 10)
  return false if n.even?
  return false if n <= 1
  return true if n <= 3

  r = 0
  d = n - 1
  while d.even?
    r += 1
    d /= 2
  end

  k.times do
    a = 2 + rand(n - 4)
    x = pow_mod(a, d, n)
    next if x == 1 || x == n - 1

    (r - 1).times do
      x = pow_mod(x, 2, n)
      return false if x == 1
      break if x == n - 1
    end

    return false if x != n - 1
  end

  true
end

def generate_prime(bits)
  n = 0
  loop do
    n = OpenSSL::BN.rand(bits).to_i
    n |= (1 << bits - 1) | 1

    break if is_prime?(n)
  end
  n
end

def generate_params
  q = generate_prime(1024)
  p = 0

  loop do
    k = rand(2**512...2**1024) # Вибір великого випадкового числа k
    p = k * q + 1
    break if is_prime?(p)
  end

  g = find_generator(p, q)

  [p, q, g]
end

def find_generator(p, q)
  h = 2
  while h < p - 1
    g = h.pow((p - 1) / q, p)
    return g if g > 1

    h += 1
  end
end

def generate_keys(g, p, q)
  x = rand(2...q)
  y = g.pow(x, p)
  [x, y]
end

def sign(message, p, q, g, x)
  k = rand(1...q)
  r = 0
  s = 0

  while r.zero? || s.zero?
    r = g.pow(k, p) % q
    break if r.zero?

    k_inv = invmod(k, q)
    hash = sha1(message).to_i(16)
    s = (k_inv * (hash + x * r)) % q
    k = rand(1...q) if s.zero?
  end

  [r, s]
end

def verify(message, r, s, p, q, g, y)
  return false if r <= 0 || r >= q || s <= 0 || s >= q

  w = invmod(s, q)
  hash = sha1(message).to_i(16)
  u1 = (hash * w) % q
  u2 = (r * w) % q
  v = ((g.pow(u1, p) * y.pow(u2, p)) % p) % q
  v == r
end

p, q, g = generate_params

pp [p, q, g]
x, y = generate_keys(g, p, q)

message = 'Test message for lab11_2.rb'

r, s = sign(message, p, q, g, x)

valid = verify(message, r, s, p, q, g, y)
puts "Чи дійсний підпис: #{valid ? 'Так' : 'Ні'}"
