def mod_exp(base, exponent, modulus)
  result = 1
  base = base % modulus

  while exponent > 0
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

n = 37
k = 10
if miller_rabin_test(n, k)
  puts "#{n} є простим числом з ймовірністю #{(1 - 4.0**-k).round(10)}"
else
  puts "#{n} є складеним числом"
end
