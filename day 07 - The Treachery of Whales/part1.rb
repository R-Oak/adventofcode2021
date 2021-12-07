lines = IO.readlines("input.txt").map { |line| line.strip }

crabs = lines[0].split(",").map { |f| f.to_i }
max_crab = crabs.max

min_fuel = max_crab * max_crab
min_pos = 0
max_crab.times do |pos|
  fuel = crabs.map { |c| (c - pos).abs }.sum
  min_fuel = fuel if fuel < min_fuel
end

print min_fuel,"\n"
