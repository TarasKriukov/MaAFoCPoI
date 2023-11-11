SUB_KEY_LIST = Array.new(16) { Array.new(8) }

IPtable = [58, 50, 42, 34, 26, 18, 10, 2,
           60, 52, 44, 36, 28, 20, 12, 4,
           62, 54, 46, 38, 30, 22, 14, 6,
           64, 56, 48, 40, 32, 24, 16, 8,
           57, 49, 41, 33, 25, 17,  9, 1,
           59, 51, 43, 35, 27, 19, 11, 3,
           61, 53, 45, 37, 29, 21, 13, 5,
           63, 55, 47, 39, 31, 23, 15, 7]

EPtable = [32,  1,  2,  3,  4,  5,
            4,  5,  6,  7,  8,  9,
            8,  9, 10, 11, 12, 13,
           12, 13, 14, 15, 16, 17,
           16, 17, 18, 19, 20, 21,
           20, 21, 22, 23, 24, 25,
           24, 25, 26, 27, 28, 29,
           28, 29, 30, 31, 32,  1]

PFtable = [16,  7, 20, 21, 29, 12, 28, 17,
            1, 15, 23, 26,  5, 18, 31, 10,
            2,  8, 24, 14, 32, 27,  3,  9,
           19, 13, 30,  6, 22, 11,  4, 25]

FPtable = [40, 8, 48, 16, 56, 24, 64, 32,
           39, 7, 47, 15, 55, 23, 63, 31,
           38, 6, 46, 14, 54, 22, 62, 30,
           37, 5, 45, 13, 53, 21, 61, 29,
           36, 4, 44, 12, 52, 20, 60, 28,
           35, 3, 43, 11, 51, 19, 59, 27,
           34, 2, 42, 10, 50, 18, 58, 26,
           33, 1, 41,  9, 49, 17, 57, 25]


S_BOX = Array.new(8) { Array.new(64, 0) }

S_BOX[0] = [14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
             0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
             4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
            15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13]

S_BOX[1] = [15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
             3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
             0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
            13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9]

S_BOX[2] = [10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
            13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
            13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
             1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12]

S_BOX[3] = [ 7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
            13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
            10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
             3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14]

S_BOX[4] = [ 2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
            14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
             4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
            11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3]

S_BOX[5] = [12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
            10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
             9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
             4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13]

S_BOX[6] = [ 4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
            13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
             1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
             6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12]

S_BOX[7] = [13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
             1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
             7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
             2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11]

PC1_TABLE = [57, 49, 41, 33, 25, 17,  9,
             1, 58, 50, 42, 34, 26, 18,
             10,  2, 59, 51, 43, 35, 27,
             19, 11,  3, 60, 52, 44, 36,
             63, 55, 47, 39, 31, 23, 15,
             7, 62, 54, 46, 38, 30, 22,
             14,  6, 61, 53, 45, 37, 29,
             21, 13,  5, 28, 20, 12,  4]

PC2_TABLE = [14, 17, 11, 24,  1,  5,  3, 28,
             15,  6, 21, 10, 23, 19, 12,  4,
             26,  8, 16,  7, 27, 20, 13,  2,
             41, 52, 31, 37, 47, 55, 30, 40,
             51, 45, 33, 48, 44, 49, 39, 56,
             34, 53, 46, 42, 50, 36, 29, 32]

def bit_to_byte(bit_list)
  bit_list.each_slice(8).map do |bits|
    bits.join.to_i(2)
  end
end

def byte_to_bit(byte_list)
  byte_list = byte_list.map do |byte|
    if [true, false].include?(byte)
      byte ? 1 : 0
    else
      byte
    end
  end

  (0...(8 * byte_list.length)).map do |i|
    (byte_list[i / 8] >> (7 - (i % 8))) & 0x01
  end
end

def perm_bit_list(input_bit_list, perm_table)
  perm_table.map { |e| input_bit_list[e - 1] }
end

def perm_byte_list(in_byte_list, perm_table)
  out_byte_list = Array.new(perm_table.length >> 3, 0)
  perm_table.each_with_index do |elem, index|
    i = index % 8
    e = (elem - 1) % 8
    if i >= e
      out_byte_list[index >> 3] |= (in_byte_list[(elem - 1) >> 3] & (128 >> e)) >> (i - e)
    else
      out_byte_list[index >> 3] |= (in_byte_list[(elem - 1) >> 3] & (128 >> e)) << (e - i)
    end
  end
  out_byte_list
end

def get_index(in_bit_list)
  (in_bit_list[0] << 5) + (in_bit_list[1] << 3) +
    (in_bit_list[2] << 2) + (in_bit_list[3] << 1) +
    (in_bit_list[4] << 0) + (in_bit_list[5] << 4)
end

def pad_data(string)
  pad_length = 8 - (string.length % 8)
  string.bytes + [pad_length] * pad_length
end

def unpad_data(byte_list)
  byte_list[0...-byte_list[-1]].map { |e| e.chr }.join
end

def left_shift(in_key_bit_list, round)
  ls_table = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]
  out_key_bit_list = Array.new(56, 0)
  if ls_table[round] == 2
    out_key_bit_list[0...26] = in_key_bit_list[2...28] + in_key_bit_list[0..1]
    out_key_bit_list[28...54] = in_key_bit_list[30...56] + in_key_bit_list[28..29]
  else
    out_key_bit_list[0...27] = in_key_bit_list[1...28] + [in_key_bit_list[0]]
    out_key_bit_list[28...55] = in_key_bit_list[29...56] + [in_key_bit_list[28]]
  end
  out_key_bit_list
end

def set_key(key)
  key_byte_list = if key.is_a?(String)
                    key.scan(/../).map { |x| x.hex }
                  elsif key.is_a?(Array)
                    key
                  else
                    raise ArgumentError, 'Ключ має бути шістнадцятковим рядком або масивом байтових значень'
                  end

  perm_key_bit_list = perm_bit_list(byte_to_bit(key_byte_list), PC1_TABLE)
  16.times do |round|
    aux_bit_list = left_shift(perm_key_bit_list, round)
    SUB_KEY_LIST[round] = bit_to_byte(perm_bit_list(aux_bit_list, PC2_TABLE))
    perm_key_bit_list = aux_bit_list
  end

  SUB_KEY_LIST
end

def encrypt_block(input_block)
  input_data = perm_byte_list(input_block, IPtable)
  left_part, right_part = input_data[0...4], input_data[4...8]
  16.times do |round|
    exp_right_part = perm_byte_list(right_part, EPtable)
    key = SUB_KEY_LIST[round]
    index_list = byte_to_bit(key.zip(exp_right_part).map { |i, j| i ^ j })
    s_box_output = Array.new(4, 0)
    4.times do |n_box|
      n_box12 = 12 * n_box
      left_index = get_index(index_list[n_box12...n_box12+6])
      right_index = get_index(index_list[n_box12+6...n_box12+12])
      s_box_output[n_box] = (S_BOX[n_box << 1][left_index] << 4) +
        S_BOX[(n_box << 1) + 1][right_index]
    end
    aux = perm_byte_list(s_box_output, PFtable)
    new_right_part = aux.zip(left_part).map { |i, j| i ^ j }
    left_part = right_part
    right_part = new_right_part
  end
  perm_byte_list(right_part + left_part, FPtable)
end

def decrypt_block(input_block)
  input_data = perm_byte_list(input_block, IPtable)
  left_part, right_part = input_data[0...4], input_data[4...8]
  16.times do |round|
    exp_right_part = perm_byte_list(right_part, EPtable)
    key = SUB_KEY_LIST[15 - round]
    index_list = byte_to_bit(key.zip(exp_right_part).map { |i, j| i ^ j })
    s_box_output = Array.new(4, 0)
    4.times do |n_box|
      n_box12 = 12 * n_box
      left_index = get_index(index_list[n_box12...n_box12+6])
      right_index = get_index(index_list[n_box12+6...n_box12+12])
      s_box_output[n_box] = (S_BOX[n_box * 2][left_index] << 4) +
        S_BOX[n_box * 2 + 1][right_index]
    end
    aux = perm_byte_list(s_box_output, PFtable)
    new_right_part = aux.zip(left_part).map { |i, j| i ^ j }
    left_part = right_part
    right_part = new_right_part
  end
  perm_byte_list(right_part + left_part, FPtable)
end

def encrypt(key, in_string)
  set_key(key)
  in_byte_list = pad_data(in_string)
  out_byte_list = []

  (0...in_byte_list.length).step(8) do |i|
    out_byte_list += encrypt_block(in_byte_list[i...i+8])
  end

  out_byte_list
end

def decrypt(key, in_byte_list)
  set_key(key)
  out_byte_list = []

  (0...in_byte_list.length).step(8) do |i|
    out_byte_list += decrypt_block(in_byte_list[i...i+8])
  end

  unpad_data(out_byte_list)
end

key = '0E329232EA6D0D73'
plaintext = "This is a test message for encryption."
ciphertext = encrypt(key, plaintext)

puts "Текст для шифрування: #{plaintext}"
puts "Зашифрований текст: #{ciphertext.pack('C*').unpack1('H*')}"
puts "Розшифрований текст: #{decrypt(key, ciphertext)}"
