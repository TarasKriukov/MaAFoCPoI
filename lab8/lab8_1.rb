def is_prime?(n, k = 10)
  return false if n <= 1 || n == 4
  return true if n <= 3

  d = n - 1
  d /= 2 while d.even?

  k.times do
    a = 2 + rand(n - 4)
    x = a.pow(d, n)
    next if x == 1 || x == n - 1

    while d != n - 1
      x = x.pow(2, n)
      d *= 2
      return true if x == 1
      return false if x == n - 1
    end

    return false
  end

  true
end

def generate_large_prime(bits)
  loop do
    n = Random.rand(2**(bits - 1)..2**bits - 1) | 1
    return n if is_prime?(n)
  end
end

def primitive_root(p)
  return 2 if [2, 3].include?(p)

  phi = p - 1
  factors = prime_factors(phi)

  (2...p).each do |g|
    return g if factors.none? { |factor| g.pow(phi / factor, p) == 1 }
  end
end

def prime_factors(n)
  factors = []
  d = 2
  while d * d <= n
    while (n % d).zero?
      factors << d
      n /= d
    end
    d += 1
  end
  factors << n if n > 1
  factors.uniq
end

def generate_keys(p, g)
  private_key = rand(2...p - 1)
  public_key = g.pow(private_key, p)
  [private_key, public_key]
end

p = generate_large_prime(64)
g = primitive_root(p)

puts "p = #{p}"
puts "g = #{g}"

alice_private_key, alice_public_key = generate_keys(p, g)
bob_private_key, bob_public_key = generate_keys(p, g)

puts "\nАліса: \n\tПриівтний ключ: #{alice_private_key} \n\tПублічний ключ: #{alice_public_key}"
puts "\nБоб: \n\tПриівтний ключ: #{bob_private_key} \n\tПублічний ключ: #{bob_public_key}\n\n"

alice_shared_secret = bob_public_key.pow(alice_private_key, p)
bob_shared_secret = alice_public_key.pow(bob_private_key, p)

if alice_shared_secret == bob_shared_secret
  puts "Обмін ключами успішний. Спільний секретний ключ: #{alice_shared_secret}"
else
  puts 'Помилка в обміні ключами.'
end
