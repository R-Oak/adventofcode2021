data = IO.readlines("input.txt").map do |line|
  line.strip
end.map do |line|
  line.chars.map { |num| num.to_i }
end

low_points = []

width = data[0].length
height = data.length

height.times do |row|
  width.times do |col|
    is_low = true
    if row > 0
      if data[row - 1][col] <= data[row][col]
        is_low = false
      end
    end
    if row < height - 1
      if data[row + 1][col] <= data[row][col]
        is_low = false
      end
    end
    if col > 0
      if data[row][col - 1] <= data[row][col]
        is_low = false
      end
    end
    if col < width - 1
      if data[row][col + 1] <= data[row][col]
        is_low = false
      end
    end
    low_points += [data[row][col] + 1] if is_low
  end
end

print low_points.sum, "\n"
