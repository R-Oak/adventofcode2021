class Player
  def initialize(pos)
    @pos = pos
    @score = 0
  end

  def pos
    @pos
  end

  def score
    @score
  end

  def move(num)
    @pos = (@pos + num) % 10
    @score += (@pos == 0) ? 10 : @pos
  end
end

class Die
  @@rolls = 0

  def initialize
    @val = 1
  end

  def roll3
    @@rolls += 3
    result = 0

    3.times do |_|
      result += @val
      @val += 1
      @val = 1 if @val == 101
    end

    result
  end

  def self.rolls
    @@rolls
  end
end

players = [
  Player.new(4),
  Player.new(2)
]
die = Die.new

while true
  player = players.shift

  player.move(die.roll3)
  if player.score >= 1000
    break
  end

  players += [player]
end

print players[0].score, " ", Die.rolls, "\n"
print players[0].score * Die.rolls, "\n"
