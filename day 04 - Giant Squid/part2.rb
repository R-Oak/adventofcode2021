infile = File.new("input.txt")

numbers = infile.readline().split(',').map { |n| n.to_i }

class Board
  def initialize(infile)
    @board = []
    5.times do
      @board += infile.readline.split(' ').map { |n| [n.to_i, false] }
    end
  end

  def call(num)
    @board = @board.map do |n, called|
      [n, (n == num) ? true : called]
    end
  end

  def cell(x, y)
    @board[y * 5 + x]
  end

  def winner?
    5.times do |row|
      win = true
      5.times do |col|
        n, called = cell(row, col)
        win = false if called == false
      end
      return true if win
    end

    5.times do |col|
      win = true
      5.times do |row|
        n, called = cell(row, col)
        win = false if called == false
      end
      return true if win
    end
    false
  end

  def unmarked
    sum = 0
    @board.each { |n, c| sum += n if c == false }
    sum
  end
end

boards = []
while true do
  begin
    # blank line
    infile.readline
    boards += [Board.new(infile)]
  rescue
    break
  end
end

numbers.each do |num|
  boards.each do |board|
    board.call(num)
    if boards.length == 1 && board.winner?
      p num
      p num * board.unmarked
      exit
    end
  end
  boards = boards.select { |board| !board.winner? }
end
