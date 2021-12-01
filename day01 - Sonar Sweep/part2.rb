depths = IO.readlines("input.txt").map { |depth| depth.strip.to_i }

total = 0
current = depths[0] + depths[1] + depths[2]

depths.each_with_index do |depth, index|
  window = 0
  3.times { |i| window += depths[index + i] }
  if window > current
    total += 1
  end
  current = window
rescue
  print total
  break
end
