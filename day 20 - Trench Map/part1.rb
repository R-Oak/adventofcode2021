require 'set'

class Image
  class << self
    def load(infile)
      pixels = Set.new
      row = 0
      while true
        begin
          infile.readline.strip.chars.each_with_index { |c, i| pixels.add([i, row]) if c == '#' }
          row += 1
        rescue
          break
        end
      end

      Image.new(pixels)
    end
  end

  def initialize(pixels, outside = false)
    @pixels = pixels
    @width = width
    @height = height
    @outside = outside
  end

  def width
    width = 0
    @pixels.each do |x, _|
      width = x if x > width
    end
    width + 1
  end

  def height
    height = 0
    @pixels.each do |_, y|
      height = y if y > height
    end
    height + 1
  end

  def to_s
    result = ""
    @height.times do |y|
      @width.times do |x|
        result += @pixels.include?([x, y]) ? '#' : '.'
      end
      result += "\n"
    end
    result
  end

  def pixel(x, y)
    return @outside if x < 0 || y < 0 || x >= @width || y >= @height
    @pixels.include?([x,y])
  end

  def enhance_pixel(x, y, enhancement)
    index = 0
    (y-1..y+1).each do |j|
      (x-1..x+1).each do |i|
        index *= 2
        index += 1 if pixel(i,j)
      end
    end
    enhancement[index] == '#'
  end

  def enhance(enhancement)
    new_pixels = Set.new
    (-1..@height).each do |y|
      (-1..@width).each do |x|
        new_pixels.add([x+1, y+1]) if enhance_pixel(x, y, enhancement)
      end
    end
    Image.new(new_pixels, !@outside)
  end

  def count_pixels
    @pixels.length
  end
end

infile = File.new("input.txt")

enhancement = infile.readline.strip
infile.readline

image = Image.load(infile)
2.times do |_|
  image = image.enhance(enhancement)
  # print "#{image.pixel(-1, -1)}\n"
  # print image, "\n"
end

print image.count_pixels, "\n"
