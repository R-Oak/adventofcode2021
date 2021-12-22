require 'set'

class Cmd
  class << self
    def parse(str)
      cmd, ranges = str.split(' ')
      case cmd
      when 'on'
        OnCmd.new(parse_ranges(ranges))
      when 'off'
        OffCmd.new(parse_ranges(ranges))
      else
        raise "Unknown cmd #{cmd}"
      end
    end

    def parse_ranges(str)
      str.split(',').map { |range| parse_range(range) }
    end

    def parse_range(str)
      lo, hi = str[2..-1].split("..")
      (lo.to_i..hi.to_i)
    end
  end

  def initialize(ranges)
    @ranges = ranges
  end

  def each_cube(&block)
    @ranges[0].each do |x|
      next if x < -50 || x > 50
      @ranges[1].each do |y|
        next if y < -50 || y > 50
        @ranges[2].each do |z|
          next if z < -50 || z > 50
          block.call(x, y, z)
        end
      end
    end
  end
end

class OnCmd < Cmd
  def run(reactor)
    each_cube { |x, y, z| reactor.add([x,y,z]) }
    reactor
  end
end

class OffCmd < Cmd
  def run(reactor)
    each_cube { |x, y, z| reactor.delete([x,y,z]) }
    reactor
  end
end

cmds = IO.readlines("input.txt").map { |line| Cmd.parse(line.strip) }

reactor = Set.new

cmds.each { |cmd| reactor = cmd.run(reactor) }

print reactor.length, "\n"
