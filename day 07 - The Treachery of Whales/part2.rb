lines = IO.readlines("input.txt").map { |line| line.strip }

crabs = lines[0].split(",").map { |f| f.to_i }
max_crab = crabs.max

fuel_cost = { 0 => 0 }
max_crab.times { |i| fuel_cost[i + 1] = fuel_cost[i] + (i + 1) }

# 10.times { |i| print "#{fuel_cost[i]}\n" }

min_fuel = max_crab * fuel_cost[max_crab]
min_pos = 0
max_crab.times do |pos|
  fuel = crabs.map { |c| fuel_cost[(c - pos).abs] }.sum
  min_fuel = fuel if fuel < min_fuel
end

print min_fuel,"\n"
