require 'securerandom'
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

  format('%08x%08x%08x%08x%08x', h0, h1, h2, h3, h4)
end

def generate_ecdsa_keys(g, a, mod, n)
  x = rand(1...n)
  q = point_multiply(g, x, a, mod)
  [x, q]
end

def mod_inverse(a, m)
  a = a % m
  (1..m).find { |i| (a * i) % m == 1 } || 1
end

# Rubocop: disable Metrics/AbcSize, Metrics/MethodLength, Nameming/MethosParameterName
def point_add(p, q, a, mod)
  return q if p.nil?
  return p if q.nil?

  if p == q
    return nil if (p[1]).zero?

    m = ((3 * p[0]**2 + a) * mod_inverse(2 * p[1], mod)) % mod
  else
    return nil if p[0] == q[0]

    m = ((q[1] - p[1]) * mod_inverse(q[0] - p[0], mod)) % mod
  end

  x_r = (m**2 - p[0] - q[0]) % mod
  y_r = (m * (p[0] - x_r) - p[1]) % mod

  [x_r, y_r]
end

def point_double(p, a, mod)
  return nil if p.nil? || (p[1]).zero?

  m = ((3 * p[0]**2 + a) * mod_inverse(2 * p[1], mod)) % mod
  x_r = (m**2 - 2 * p[0]) % mod
  y_r = (m * (p[0] - x_r) - p[1]) % mod

  [x_r, y_r]
end

def point_multiply(p, n, a, mod)
  q = nil
  n.to_s(2).each_char do |bit|
    q = point_double(q, a, mod)
    q = point_add(q, p, a, mod) if bit == '1'
  end
  q
end

def find_order_of_point(g, a, mod)
  current_point = g
  n = 1

  while current_point
    n += 1
    current_point = point_add(current_point, g, a, mod)
  end

  n
end

def ecdsa_sign(message, x, a, mod, g, n)
  h = sha1(message).to_i(16)
  r = 0
  s = 0

  while r.zero? || s.zero?
    k = rand(1...n)
    x1, = point_multiply(g, k, a, mod)
    r = x1 % n
    next if r.zero?

    s = (mod_inverse(k, n) * (h + x * r)) % n
  end

  [r, s]
end

# Перевірка підпису ECDSA
def ecdsa_verify(message, r, s, q, a, mod, g, n)
  return false if [r, s].any? { |val| val <= 0 || val >= n }

  h = sha1(message).to_i(16)
  w = mod_inverse(s, n)
  u1 = (h * w) % n
  u2 = (r * w) % n
  x1, y1 = point_add(point_multiply(g, u1, a, mod), point_multiply(q, u2, a, mod), a, mod)
  x1 % n == r
end

a = 1
mod = 23
g = [17, 20]
n = find_order_of_point(g, a, mod)

puts "Порядок n точки G = #{g.inspect} на еліптичній кривій дорівнює: #{n}"

# Генерація ключів
x, q = generate_ecdsa_keys(g, a, mod, n)
puts "Приватний ключ 'x': #{x}, та публічний ключ 'Q': #{q}"

# Підписування та перевірка
message = 'Hello, world!'
r, s = ecdsa_sign(message, x, a, mod, g, n)
puts "Підпис: (r: #{r}, s: #{s})"
puts "Підпис валідний: #{ecdsa_verify(message, r, s, q, a, mod, g, n)}"
