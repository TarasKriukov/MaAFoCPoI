def elliptic_curve_points(a, b, p)
  points = []
  p.times do |x|
    right_side = (x**3 + a * x + b) % p
    p.times do |y|
      points << [x, y] if y**2 % p == right_side
    end
  end
  points
end

a = 1
b = 1
p = 23

puts elliptic_curve_points(a, b, p).inspect
