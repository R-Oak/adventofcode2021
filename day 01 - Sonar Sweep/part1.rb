depths = IO.readlines("input.txt")

total = 0
current = depths[0].strip.to_i

depths.map{ |depth| depth.strip.to_i }.each do |depth|
  if depth > current
    total += 1
  end
  current = depth
end

print total
