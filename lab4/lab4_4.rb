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

def gcdex(a, b)
  x0, x1, y0, y1 = 1, 0, 0, 1

  while b != 0
    q, r = a.divmod(b)
    a, b = b, r
    x0, x1 = x1, x0 - q * x1
    y0, y1 = y1, y0 - q * y1
  end

  [a, x0, y0]
end

def inverse_element_2(a, n)
  if gcdex(a, n)[0] != 1
    "Елемент не має мультиплікативного оберненого елемента за модулем #{n}"
  else
    a.pow(phi(n) - 1, n)
  end
end

a, n = 5, 18
inverse = inverse_element_2(a, n)
puts "Мультиплікативний обернений елемент числа #{a} за модулем #{n} дорівнює #{inverse}"
