grid = IO.readlines("input.txt").map { |line| line.strip.chars.map { |c| c.to_i } }

# grid.each { |row| print row, "\n" }
# print "\n"

width = grid[0].length
height = grid.length

print "#{width} #{height}\n"

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

# height.times do |x|
#   width.times do |y|
#     print "#{scores[[x,y]]}".rjust(3), " "
#   end
#   print "\n"
# end
# print "\n"


print scores[[width-1,height-1]], "\n"
