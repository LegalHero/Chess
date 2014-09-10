require_relative "Board"

class Game
  attr_reader :player1, :player2, :board
  
  def initialize(name1, name2)
    @board = Board.new
    @player1, @player2 = Player.new(name1, "B"), Player.new(name2, "W")
  end
  
  def play
    until gameover?
      board.display
      player1.make_move(board)
      
      winner if gameover?
      
      board.display
      player2.make_move
    end
    
    winner
  end
  
  def gameover?
    board.checkmate?("W") || board.checkmate?("B")
  end
  
  def winner
    winner = board.checkmate?("W") ? player1 : player2
    puts "#{winner.name.capitalize} wins!"
    exit
  end
end

class Player
  attr_reader :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end
end