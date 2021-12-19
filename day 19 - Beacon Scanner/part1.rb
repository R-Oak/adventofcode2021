class Scanner
  class << self
    def load(infile)
      beacons = []
      infile.readline # '--- scanner 0 ---'
      while true
        begin
          line = infile.readline.strip
          break if line.empty?

          beacons += [line.split(',').map { |num| num.to_i }]
        rescue
          break
        end
      end
      Scanner.new(beacons)
    end
  end

  def initialize(beacons)
    @beacons = beacons
    @x = 0
    @y = 0
    @z = 0
    @orientation = orientations[0]
  end

  def set_pos(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def set_orientation(orientation)
    @orientation = orientation
  end

  def beacons
    @beacons.map do |beacon|
      b = orient_beacon(beacon, @orientation)
      [b[0] + @x, b[1] + @y, b[2] + @z]
    end
  end

  def orient_beacon(beacon, orientation)
    result = [
      beacon[orientation[0]],
      beacon[orientation[2]],
      beacon[orientation[4]]
    ]
    result[0] *= -1 unless orientation[1]
    result[1] *= -1 unless orientation[3]
    result[2] *= -1 unless orientation[5]
    result
  end

  def relative_beacons
    @beacons.map do |beacon|
      b = orient_beacon(beacon, @orientation)
    end
  end
end

def orientations
  [
    [0, true, 1, true, 2, true],
    [0, true, 2, true, 1, false],
    [0, true, 1, false, 2, false],
    [0, true, 2, false, 1, true],

    [0, false, 1, false, 2, true],
    [0, false, 2, true, 1, true],
    [0, false, 1, true, 2, false],
    [0, false, 2, false, 1, false],

    [1, true, 0, true, 2, false],
    [1, true, 2, false, 0, false],
    [1, true, 0, false, 2, true],
    [1, true, 2, true, 0, true],

    [1, false, 0, true, 2, true],
    [1, false, 2, true, 0, false],
    [1, false, 0, false, 2, false],
    [1, false, 2, false, 0, true],

    [2, true, 0, true, 1, true],
    [2, true, 1, true, 0, false],
    [2, true, 0, false, 1, false],
    [2, true, 1, false, 0, true], 

    [2, false, 0, true, 1, false],
    [2, false, 1, false, 0, false],
    [2, false, 0, false, 1, true],
    [2, false, 1, true, 0, true],
  ]
end

def common(beacons1, beacons2)
  result = 0
  beacons1.each { |beacon| result += 1 if beacons2.include?(beacon) }
  result
end

def overlaps(scanner1, scanner2)
  beacons = scanner1.beacons
  beacons.each do |beacon|
    scanner2.relative_beacons.each do |b|
      # assume 'b' is 'beacon'
      # print "trying #{[beacon[0] - b[0], beacon[1] - b[1], beacon[2] - b[2]]}\n"
      scanner2.set_pos(beacon[0] - b[0], beacon[1] - b[1], beacon[2] - b[2])
      common = common(beacons, scanner2.beacons)
      if common >= 12
        # print "#{beacons}\n"
        # print "#{scanner2.beacons} #{common}\n"
        return scanner2
      end
    end
  end
  return nil
end

input = []
infile = File.new("input.txt")

while !infile.eof?
  input += [Scanner.load(infile)]
end

# scanner = nil
# orientations.each do |orient|
#   scanner = input[1]
#   scanner.set_orientation(orient)
#   scanner = overlaps(input[0], scanner)
#   break if scanner
# end
# print scanner.beacons
# print "\n\n\n\n"

# scanner1 = scanner
# orientations.each do |orient|
#   scanner = input[4]
#   scanner.set_orientation(orient)
#   scanner = overlaps(scanner1, scanner)
#   break if scanner
# end

# print scanner, "\n"

# exit

scanner = input.shift
scanners = [scanner]

while !input.empty?
  in_scanner = input.shift
  found_common = false
  orientations.each do |orient|
    in_scanner.set_orientation(orient)
    scanners.each do |scanner|
      s = overlaps(scanner, in_scanner)
      if s
        found_common = true
        scanners += [s]
        print scanners.length, "\n"
        break
      end
    end

    if found_common
      break
    end
  end
  input += [in_scanner] unless found_common
end

scanners.each {|scanner| p scanner }

beacons = []

scanners.each do |scanner|
  beacons += scanner.beacons
end

print beacons.uniq.length, "\n"
