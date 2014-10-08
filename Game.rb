class InvalidInputError < StandardError
end

require_relative "Board"

class Game
  attr_reader :player1, :player2, :board
  
  def initialize(name1, name2, board = Board.new)
    @board = board
    @player1, @player2 = Player.new(name1, "B"), Player.new(name2, "W")
  end
  
  def play
    until gameover?
      display
      player1.make_move(board)
      
      winner if gameover?
      
      display
      player2.make_move(board)
    end
    
    winner
  end
  
  def display
    puts "\n#{player1.name} has captured"
    puts "#{player1.captured}"
    board.display
    puts "\n#{player2.captured}"
    puts "#{player2.name} has captured"
  end
  
  def gameover?
    board.checkmate?("W") || board.checkmate?("B")
  end
  
  def winner
    winner = board.checkmate?("W") ? player1 : player2
    display
    puts "\nCheckmate! \n#{winner.name.capitalize} wins!"
    puts
    
    exit
  end
end

class Player
  attr_reader :name, :color
  attr_accessor :captured
  
  def initialize(name, color)
    @name = name
    @color = color
    @captured = []
  end
  
  def make_move(board)
    from = get_from(board)
    to = get_to(board, from)
    maybe_captured = board.move(from, to)
    @captured << maybe_captured.symbol if maybe_captured
  end
  
  def get_from(board)
    begin
      puts "\nWhere would like you to move from, #{name.capitalize}? (Ex. A5)"
      from = parse_input(gets.chomp)
      board.can_move_from?(color, from)
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
    
    from
  end
  
  def get_to(board, from)
    begin
      puts "\nWhere would like you to move to? Available moves:"
      p untransform(board.valid_moves(from))
      to = parse_input(gets.chomp)
      board.can_move_to?(from, to)
    rescue InvalidInputError
      puts "\nThat is not a valid input!"
      retry
    rescue CantMoveThereError
      puts "\nThat's not in your list of valid moves!"
      retry
    rescue CantMoveIntoCheckError
      puts "\nYou can't move into check!"
      retry
    end
    
    to
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
  
  def untransform(moves)
    letters = ("A".."H").to_a
    
    moves.map do |move|
      move[0] = letters[move[0]]
      move.join
    end.join(", ")
  end
end