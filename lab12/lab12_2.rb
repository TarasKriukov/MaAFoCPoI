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

def find_order_of_point(g, a, mod)
  current_point = g
  n = 1

  while current_point
    n += 1
    current_point = point_add(current_point, g, a, mod)
    puts "Порядок n точки G = #{current_point.inspect} на еліптичній кривій дорівнює: #{n}"
  end

  n
end

a = 1
mod = 23

g = [17, 20]

order = find_order_of_point(g, a, mod)
puts "\n\nФінальний порядок n точки G = #{g.inspect} на еліптичній кривій дорівнює: #{order}"
