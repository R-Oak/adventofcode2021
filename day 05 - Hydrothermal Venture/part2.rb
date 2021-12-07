@grid = Array.new(1000 * 1000, 0)

def cell(x, y)
  @grid[y * 1000 + x]
end

def set_cell(x, y, val)
  @grid[y * 1000 + x] = val
end

IO.readlines("input.txt").map { |line| line.strip }.each do |line|
  strCoords = line.split(" -> ")
  x1,y1 = strCoords[0].split(",").map { |i| i.to_i }
  x2,y2 = strCoords[1].split(",").map { |i| i.to_i }
  # print "#{x1},#{y1} #{x2},#{y2}\n"

  xadd = if x1 == x2
    0
  elsif x1 > x2
    -1
  else
    1
  end

  yadd = if y1 == y2
    0
  elsif y1 > y2
    -1
  else
    1
  end

  # print "#{xadd},#{yadd}\n"
  x = x1
  y = y1
  set_cell(x, y, cell(x, y) + 1)

  while x != x2 || y != y2
    x += xadd
    y += yadd
    set_cell(x, y, cell(x, y) + 1)
  end
end

# 10.times do |row|
#   10.times do |col|
#     print "#{cell(col, row) }"
#   end
#   print "\n"
# end

p @grid.select { |n| n > 1 }.length
