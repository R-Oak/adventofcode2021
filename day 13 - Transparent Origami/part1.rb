
class Paper
  def initialize(dots)
    @dots = dots
  end

  def num_dots
    @dots.length
  end

  def print_paper
    height.times do |row|
      width.times do |col|
        if @dots.include?([col, row])
          print("#")
        else
          print(".")
        end
      end
      print "\n"
    end
    print "\n"
  end

  def fold_x(fold)
    new_dots = @dots.map do |x, y|
      if x < fold
        [x, y]
      else
        [fold - (x - fold), y]
      end
    end
    Paper.new(new_dots.uniq)
  end
  
  def fold_y(fold)
  new_dots = @dots.map do |x, y|
    if y < fold
      [x, y]
    else
      [x, fold - (y - fold)]
    end
  end
  Paper.new(new_dots.uniq)
end

  def width
    (@dots.map { |x, _| x }).max + 1
  end

  def height
    (@dots.map { |_, y| y }).max + 1
  end
end

infile = File.new("input.txt")
dots = []

while true
  line = infile.readline.strip
  break if line.empty?

  x, y = line.split(",")
  dots += [[x.to_i, y.to_i]]
end

print dots, "\n"

paper = Paper.new(dots)

while true do
  begin
    cmd,fold = infile.readline.split("=")
    if cmd[-1] == 'x'
      paper = paper.fold_x(fold.to_i)
    else
      paper = paper.fold_y(fold.to_i)
    end

    # part1, we're only doing the 1st fold
    break
  rescue
    break
  end
end

print paper.num_dots, "\n"
