lines = IO.readlines("input.txt").map { |line| line.strip }

data = lines[0].split(",").map { |f| f.to_i }

fish = {}

9.times { |i| fish[i] = 0 }
data.each { |i| fish[i] += 1 }

day = 0
while day < 256
  day += 1

  next_fish = { 8 => fish[0] }
  8.times { |i| next_fish[i] = fish[i + 1] }
  next_fish[6] += next_fish[8]
  fish = next_fish
end

num_fish = 0
fish.values.each { |num| num_fish += num }
print num_fish,"\n"
