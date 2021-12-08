
def two_string_diff(s1, s2)
  in1 = ""
  in2 = ""
  inboth = ""

  ['a','b','c','d','e','f','g'].each do |char|
    if s1.include?(char) && s2.include?(char)
      inboth += char
    elsif s1.include?(char)
      in1 += char
    elsif s2.include?(char)
      in2 += char
    end
  end
  [in1, in2, inboth]
end

def three_string_diff(strs)
  result = ["","",""]
  ['a','b','c','d','e','f','g'].each do |char|
    count = 0
    strs.each { |str| count += 1 if str.include?(char) }
    if count > 0
      result[count - 1] += char
    end
  end

  result
end

def sort_string(str)
  str.chars.sort.join
end

def solve(inputs, outputs)
  data = { 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [] }
  inputs.each { |input| data[input.length] += [sort_string(input)]}
  # print data,"\n"

  digits = {}
  digits[data[2][0]] = 1
  digits[data[3][0]] = 7
  digits[data[4][0]] = 4
  digits[data[7][0]] = 8

  # _, segA, _ = two_string_diff(data[2], data[3])
  _, _, horiz_segs = three_string_diff(data[5])
  # print horiz_segs, "\n"
  zero = ""
  data[6].each do |str|
    segD, _, _ = two_string_diff(horiz_segs, str)
    if segD != ""
      zero = str
    end
  end
  # print zero, "\n"
  digits[zero] = 0
  data[6].delete(zero)
  # print data[6]
  _, _, both = two_string_diff(data[2][0], data[6][0])
  if both.length == 2
    digits[data[6][0]] = 9
    digits[data[6][1]] = 6
  else
    digits[data[6][0]] = 6
    digits[data[6][1]] = 9
  end
  three = ""
  data[5].each do |str|
    _, _, both = two_string_diff(data[2][0], str)
    if both.length == 2
      three = str
    end
  end
  digits[three] = 3
  data[5].delete(three)
  _, _, both = two_string_diff(data[4][0], data[5][0])
  if both.length == 2
    digits[data[5][0]] = 2
    digits[data[5][1]] = 5
  else
    digits[data[5][0]] = 5
    digits[data[5][1]] = 2
  end
  # print digits, "\n"
  result = 1000 * digits[sort_string(outputs[0])] + 
    100 * digits[sort_string(outputs[1])] + 
    10 * digits[sort_string(outputs[2])] + 
    1 * digits[sort_string(outputs[3])]
end

total = 0
IO.readlines("input.txt").map { |line| line.strip }.each do |line|
  inputs,outputs = line.split(" | ")
  total += solve(inputs.split(" "), outputs.split(" "))
end

print total, "\n"

