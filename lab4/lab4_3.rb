def phi(m)
  result = m
  p = 2

  while p * p <= m
    if m % p == 0
      while m % p == 0
        m /= p
      end
      result -= result / p
    end
    p += 1
  end

  result -= result / m if m > 1

  result
end

m = 18
result = phi(m)
puts "Значення функції Ейлера для числа #{m} дорівнює #{result}"

