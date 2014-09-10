class InvalidInputError < StandardError
end

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
  
  def make_move(board)
    from = get_from(board)
    to = get_to(board, from)
  end
  
  def get_from(board)
    begin
      puts "\nWhere would like you to move from? (Ex. A5)"
      input = gets.chomp
      board.can_move_from?(color, parse_input(input))
    rescue InvalidInputError
      puts "\nThat is not a valid input!"
      retry
    rescue NoPieceError
      puts "\nYou don't have a piece there!"
      retry
    rescue NoMoveError
      puts "\nYou have no moves from there!"
      retry
    end
    
    input
  end
  
  def get_to(board, from)
  end
  
  def parse_input(input)
    raise InvalidInputError unless ("A".."H").include?(input[0]) && ("0".."7").include?(input[1]) && input.length == 2
    
    transform_input(input)
  end
  
  def transform_input(input)
    letter = input[0]
    input[0] = ("A".."H").to_a.index(letter).to_s
    
    input.split("").map(&:to_i)
  end
end