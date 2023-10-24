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

def inverse_element(a, n)
  gcd, x, _ = gcdex(a, n)

  if gcd != 1
    "Елемент не має мультиплікативного оберненого елемента за модулем #{n}"
  else
    x % n
  end
end

a, n = 5, 18
inverse = inverse_element(a, n)
puts "Мультиплікативний обернений елемент числа #{a} за модулем #{n} дорівнює #{inverse}"

