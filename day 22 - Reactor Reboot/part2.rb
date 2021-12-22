require 'set'

class Cmd
  class << self
    def parse(str, reactor)
      cmd, ranges = str.split(' ')
      case cmd
      when 'on'
        print "ON #{(parse_ranges(ranges))}\n"
      when 'off'
        print "OFF #{(parse_ranges(ranges))}\n"
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
end

reactor = Set.new

IO.readlines("input2.txt").each { |line| reactor = Cmd.parse(line.strip, reactor) }

print "#{reactor}\n"

