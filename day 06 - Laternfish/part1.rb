lines = IO.readlines("input.txt").map { |line| line.strip }

fish = lines[0].split(",").map { |f| f.to_i }

day = 0

while day < 80
  day += 1
  print day
  new_fish = 0
  fish = fish.map do |fish|
    if fish == 0
      new_fish += 1
      6
    else
      fish - 1
    end
  end
  fish += [8] * new_fish
end

print fish.length, "\n"
