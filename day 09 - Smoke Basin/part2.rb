@data = IO.readlines("input.txt").map do |line|
  line.strip
end.map do |line|
  line.chars.map { |num| num.to_i }
end

@basins = []

@width = @data[0].length
@height = @data.length

def in_basin?(x, y)
  @basins.any? { |basin| basin.include?([x,y]) }
end

def get_basin(row, col)
  result = []
  worklist = [[row, col]]

  while !worklist.empty?
    x, y = worklist.shift
    result += [[x, y]]

    if x > 0 && !result.include?([x-1,y]) && !worklist.include?([x-1,y])
      worklist += [[x-1,y]] if @data[x-1][y] != 9
    end
    if x < @height - 1 && !result.include?([x+1,y]) && !worklist.include?([x+1,y])
      worklist += [[x+1,y]] if @data[x+1][y] != 9
    end
    if y > 0 && !result.include?([x,y-1]) && !worklist.include?([x,y-1])
      worklist += [[x,y-1]] if @data[x][y-1] != 9
    end
    if y < @width - 1 && !result.include?([x,y+1]) && !worklist.include?([x,y+1])
      worklist += [[x,y+1]] if @data[x][y+1] != 9
    end
  end
  result
end

@height.times do |row|
  @width.times do |col|
    if !in_basin?(row, col) && @data[row][col] != 9
      @basins += [get_basin(row, col)]
    end
  end
end

# print @basins, "\n"
x,y,z = @basins.map { |basin| basin.length }.sort.pop(3)

print x * y * z, "\n"
