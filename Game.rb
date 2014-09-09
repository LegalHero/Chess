require_relative "Board"

class Game
  def initialize
    @board = Board.new
    @player1, @player2 = Player.new("B"), Player.new("W")
  end
end

class Player
  def initialize(color)
    @color = color
  end
end