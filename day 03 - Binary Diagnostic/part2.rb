lines = IO.readlines("input.txt").map { |line| line.strip }

def most_common_bit(list, index)
  num_0 = 0
  num_1 = 0
  list.each do |line|
    bit = line[index]
    if bit == '0'
      num_0 += 1
    else
      num_1 += 1
    end
  end
  num_0 > num_1 ? '0' : '1'
end

def least_common_bit(list, index)
  num_0 = 0
  num_1 = 0
  list.each do |line|
    bit = line[index]
    if bit == '0'
      num_0 += 1
    else
      num_1 += 1
    end
  end
  num_0 <= num_1 ? '0' : '1'
end

def bin_to_num(str)
  result = 0
  str.length.times do |index|
    result *= 2
    if str[index] == '1'
      result += 1
    end
  end
  result
end

oxygen_prefix = most_common_bit(lines, 0)
c02_prefix = least_common_bit(lines, 0)

oxygen = lines.filter { |line| line.start_with?(oxygen_prefix) }
c02 = lines.filter { |line| line.start_with?(c02_prefix) }

index = 1
while oxygen.length > 1
  # print "#{oxygen}\n"
  oxygen_prefix += most_common_bit(oxygen, index)
  oxygen = oxygen.filter { |line| line.start_with?(oxygen_prefix) }
  index += 1
end

print oxygen, "\n"

index = 1
while c02.length > 1
  # print "#{c02}\n"
  c02_prefix += least_common_bit(c02, index)
  c02 = c02.filter { |line| line.start_with?(c02_prefix) }
  index += 1
end

print c02, "\n"

print bin_to_num(oxygen[0]) * bin_to_num(c02[0]), "\n"
