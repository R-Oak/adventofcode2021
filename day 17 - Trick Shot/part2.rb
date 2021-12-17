class Target
  def initialize(filename)
    line = File.new(filename).readline.strip
    # remove the start of the line
    target = line["target area: ".length, line.length]
    xlimits, ylimits = target.split(", ")
    @minx, @maxx = get_limits(xlimits)
    @miny, @maxy = get_limits(ylimits)
  end

  def height
    @maxy - @miny
  end

  def maxx
    @maxx
  end

  def in_target?(x, y)
    x >= @minx && x <= @maxx && y >= @miny && y <= @maxy
  end

  def overshot?(x, y)
    x > @maxx || y < @miny
  end

  def try_shot?(xvel, yvel)
    xpos = 0
    ypos = 0
    max_height = 0

    while !overshot?(xpos, ypos)
      xpos += xvel
      ypos += yvel
      if xvel != 0
        xvel -= 1 if xvel > 0
        xvel += 1 if xvel < 0
      end
      yvel -= 1

      max_height = ypos if ypos > max_height

      return [true, max_height] if in_target?(xpos, ypos)
    end
    [false, -yvel]
  end

  def x_will_hit?(xvel)
    xpos = 0
    while xpos <= @maxx
      xpos += xvel
      return true if xpos >= @minx && xpos <= @maxx

      if xvel != 0
        xvel -= 1 if xvel > 0
        xvel += 1 if xvel < 0
      else
        return false
      end
    end
    false
  end

  def get_limits(str)
    # remove the 'x=' from the start of the line
    str = str[2, str.length]
    min,max = str.split("..")
    [min.to_i, max.to_i]
  end
end

target = Target.new("input.txt")

xvel = 0
yvel = 0

max_height = 0
success = 0

# while xvel <= target.maxx
#   xvel += 1
#   next unless target.x_will_hit?(xvel)
#   yvel = 0
#   while true
#     result, num = target.try_shot?(xvel, yvel)
#     print [xvel, yvel], [result, num], "\n"
#     if result
#       max_height = num if num > max_height
#     else
#       break if num > target.height
#       break if num < 0 # still going up when we overshoot
#     end
#     yvel += 1
#   end
# end

1000.times do |xvel|
  next unless target.x_will_hit?(xvel)
  1000.times do |yvel|
    result, num = target.try_shot?(xvel, yvel - 500)
    if result
      success += 1
      if num > max_height
        max_height = num
        print "#{xvel}, #{yvel-1}, #{max_height} #{success}\n"
      end
    end
  end
end

# print target.try_shot?(6,10), "\n"
print "#{xvel}, #{yvel-1}, #{max_height} #{success}\n"
