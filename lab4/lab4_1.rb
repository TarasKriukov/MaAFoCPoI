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

a, b = 612, 342
d, x, y = gcdex(a, b)
puts "d = #{d}, x = #{x}, y = #{y}"
