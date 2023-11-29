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

message = 'What a beautifull world!'
puts "Хеш за алгоритмом SHA-1: \t#{sha1(message)}"
