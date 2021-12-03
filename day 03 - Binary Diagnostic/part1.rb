lines = IO.readlines("input.txt").map { |line| line.strip }

def get_bits(line)
  result = {}
  line.length.times do |index|
    result[index] = {
      0 => line[index] == '0' ? 1 : 0,
      1 => line[index] == '1' ? 1 : 0
    }
  end
  result
end

totals = {}
lines.each do |line|
  bits = get_bits(line)
  bits.each do |index, bits|
    if totals[index]
      totals[index][0] += bits[0]
      totals[index][1] += bits[1]
    else
      totals[index] = bits
    end
  end
end

gamma = 0
epsilon = 0

totals.each do |_, bits|
  gamma *= 2
  epsilon *= 2

  if bits[0] > bits[1]
    epsilon += 1
  else
    gamma += 1
  end
end

print totals, "\n"
print gamma, "\n"
print epsilon, "\n"
print gamma * epsilon, "\n"
