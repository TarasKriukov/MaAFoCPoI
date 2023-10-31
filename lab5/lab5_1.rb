def mul02(byte)
  result = byte << 1
  result ^= 0x11b if byte & 0x80 != 0
  result & 0xff
end

def mul03(byte)
  mul02(byte) ^ byte
end

var_mul02 = 0xD4
var_mul03 = 0xBF

p "Множення на 02: #{mul02(var_mul02).to_s(16).upcase}"
p "Множення на 03: #{mul03(var_mul03).to_s(16).upcase}"
