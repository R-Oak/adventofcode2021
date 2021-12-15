tile = (IO.readlines("input.txt").map { |line| line.strip }).map { |line| line.chars.map { |c| c.to_i } }

tile_height = tile.length
tile_width = tile[0].length

width = tile[0].length * 5
height = tile.length * 5

print "#{width} #{height}\n"

grid = Array.new(height) { Array.new(width, 0) }

tile_height.times do |x|
  tile_width.times do |y|
    5.times do |i|
      5.times do |j|
        val = tile[x][y] + i + j
        if val > 9
          val -= 9
        end
        grid[i * tile_height + x][j * tile_width + y] = val
      end
    end
  end
end

# grid.each { |row| print row, "\n" }
# print "\n"

scores = {
  [0,0] => 0
}

worklist = [[0,0]]
closed = {}

while !worklist.empty?
  x, y = worklist.shift
  closed[[x, y]] = true

  [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |xadd, yadd|
    x1 = x + xadd
    y1 = y + yadd

    next if x1 < 0 || y1 < 0 || x1 >= height || y1 >= width

    score = scores[[x,y]] + grid[x1][y1]

    if scores.key?([x1, y1])
      if scores[[x1, y1]] > score
        scores[[x1, y1]] = score
        worklist += [[x1, y1]]
      end
    else
      scores[[x1,y1]] = score
      worklist += [[x1, y1]]
    end

  end
end

# scores.each { |row| print row, "\n" }

print scores[[width-1,height-1]], "\n"
