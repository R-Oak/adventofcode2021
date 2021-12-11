class Octopus
  @@num_flashes = 0

  def self.num_flashes
    @@num_flashes
  end

  def initialize(energy)
    @energy = energy
    @flashed = false
    @neighbours = []
  end

  def neighbours=(neighbours)
    @neighbours = neighbours
  end

  def print_octopus
    print @energy
  end

  def energy
    @energy
  end

  def increase_energy
    @energy += 1
  end

  def flash
    if !flashed?
      @flashed = true
      @neighbours.each { |oct| oct.increase_energy }
      @neighbours.each { |oct| oct.flash if oct.energy > 9 }
      @@num_flashes += 1
      return true
    end
    false
  end

  def flashed?
    @flashed
  end

  def reset
    if flashed?
      @energy = 0
      @flashed = false
    end
  end
end

@octopi = IO.readlines("input.txt").map { |line| line.strip.chars.map { |x| Octopus.new(x.to_i) } }

@width = @octopi[0].length
@height = @octopi.length

def neighbours(x, y)
  offset = [
    [-1, -1], [-1,  0], [-1,  1],
    [ 0, -1],           [ 0,  1],
    [ 1, -1], [ 1,  0], [ 1,  1],
  ]
  (offset.map { |xadd, yadd| [x + xadd, y + yadd]}).select do |x, y|
    x >= 0 && y >= 0 && x < @width && y < @height
  end
end

@height.times do |y|
  @width.times do |x|
    @octopi[x][y].neighbours = neighbours(x, y).map { |i, j| @octopi[i][j]}
  end
end

def print_octopi(octopi)
  octopi.each do |row|
    row.each do |oct|
      oct.print_octopus
    end
    print "\n"
  end
  print "\n"
end

print_octopi(@octopi)

def octopi_sync(octopi)
  octopi.all? { |row| row.all? { |oct| oct.flashed? } }
end

step = 0

while true
  step += 1
  @octopi.each { |row| row.each { |oct| oct.increase_energy } }
  @octopi.each { |row| row.each { |oct| oct.flash if oct.energy > 9 } }
  if octopi_sync(@octopi)
    print step, "\n"
    break
  end
  @octopi.each { |row| row.each { |oct| oct.reset } }

  # print_octopi(@octopi)
end

# print Octopus.num_flashes, "\n"
