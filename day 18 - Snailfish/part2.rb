class Snailfish
  class << self
    def parse(str)
      result, str = parse_snailfish(str)
      return result
    end

    def parse_snailfish(str)
      if str[0] == '['
        str = str.delete_prefix('[')
        left, str = parse_snailfish(str)
        str = str.delete_prefix(',')
        right, str = parse_snailfish(str)
        str = str.delete_prefix(']')
        return [SnailfishPair.new(left, right), str]
      else
        result = str[0].to_i
        str = str[1..-1]
        return [SnailfishNumber.new(result), str]
      end
    end

    def add(lhs, rhs)
      SnailfishPair.new(lhs.copy, rhs.copy).reduce
    end
  end
end

class SnailfishPair < Snailfish
  def initialize(left, right)
    @left = left
    @right = right
  end

  def to_s
    "[#{@left},#{@right}]"
  end

  def copy
    SnailfishPair.new(
      @left.copy,
      @right.copy
    )
  end

  def is_pair?
    true
  end

  def left
    @left
  end

  def right
    @right
  end

  def magnitude
    3 * @left.magnitude + 2 * @right.magnitude
  end

  def explode(depth = 0)
    if depth == 3
      if @left.is_pair?
        left = @left.left
        right = @left.right
        @left = SnailfishNumber.new(0)

        @right.add_right(right)
        return [left, nil]
      end

      if @right.is_pair?
        left = @right.left
        right = @right.right
        @right = SnailfishNumber.new(0)

        @left.add_left(left)
        return [nil, right]
      end
      return false
    else
      res = @left.explode(depth + 1)
      # print " " * depth, "L #{res} #{@right}\n"
      if res != false
        left, right = res
        unless right.nil?
          if @right.add_right(right)
            return [left, nil]
          end
        end
        return [left, right]
      end
      res = @right.explode(depth + 1)
      # print " " * depth, "R #{res} #{@left}\n"
      if res != false
        left, right = res
        unless left.nil?
          if @left.add_left(left)
            return [nil, right]
          end
        end
        return [left, right]
      end
      res
    end
  end

  def add_left(val)
    return true if @right.add_left(val)
    return true if @left.add_left(val)
    false
  end

  def add_right(val)
    return true if @left.add_right(val)
    return true if @right.add_right(val)
    false
  end

  def split
    if @left.can_split?
      @left = SnailfishPair.new(
        SnailfishNumber.new(@left.value / 2),
        SnailfishNumber.new((@left.value + 1) / 2)
      )
      return true
    end
    return true if @left.split
    if @right.can_split?
      @right = SnailfishPair.new(
        SnailfishNumber.new(@right.value / 2),
        SnailfishNumber.new((@right.value + 1) / 2)
      )
      return true
    end
    @right.split
  end

  def can_split?
    false
  end

  def reduce
    while true
      next if explode != false
      next if split
      break
    end
    self
  end
end

class SnailfishNumber < Snailfish
  def initialize(value)
    @value = value
  end

  def copy
    SnailfishNumber.new(
      @value
    )
  end

  def to_s
    @value.to_s
  end

  def is_pair?
    false
  end

  def value
    @value
  end

  def magnitude
    @value
  end

  def explode(depth = 0)
    false
  end

  def add(val)
    @value += val.value
  end

  def add_left(val)
    @value += val.value
    true
  end

  def add_right(val)
    @value += val.value
    true
  end

  def can_split?
    @value >= 10
  end

  def split
    false
  end
end

# print Snailfish.parse("[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]"), "\n"

# [
#   [
#     "[[[[[9,8],1],2],3],4]",
#     "[[[[0,9],2],3],4]"
#   ],
#   [
#     "[7,[6,[5,[4,[3,2]]]]]",
#     "[7,[6,[5,[7,0]]]]"
#   ],
#   [
#     "[[6,[5,[4,[3,2]]]],1]",
#     "[[6,[5,[7,0]]],3]"
#   ],
#   [
#     "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]",
#     "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"
#   ],
#   [
#     "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]",
#     "[[3,[2,[8,0]]],[9,[5,[7,0]]]]",
#   ]
# ].each do |test|
#   num = Snailfish.parse(test[0])
#   num.explode
#   print "#{num} != #{test[1]}\n" unless num.to_s == test[1]
# end

# num = Snailfish.add(
#   Snailfish.parse("[[[[4,3],4],4],[7,[[8,4],9]]]"),
#   Snailfish.parse("[1,1]")
# )
# print num, "\n"

# print Snailfish.parse("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]").magnitude, "\n"

numbers = IO.readlines("input.txt").map { |line| Snailfish.parse(line.strip) }

# numbers.each { |num| print num, "\n" }
# numbers.permutation(2).map do |a, b|
#   print a, "\n"
#   print b, "\n"
#   print Snailfish.add(a, b), "\n"
#   print Snailfish.add(a, b).magnitude, "\n"
#   print "\n"
# end
# exit

magnitudes = numbers.permutation(2).map do |a, b|
  Snailfish.add(a, b).magnitude
end

print magnitudes.max, "\n"
