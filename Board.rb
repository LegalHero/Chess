require_relative "Piece"
require "colorize"

class Board
  attr_accessor :grid
  
  def initialize(place_pieces = true)
    @grid = Array.new(8) { Array.new(8) }
    fill_grid if place_pieces
  end
  
  def fill_grid
    place_pawns("B").place_pawns("W").place_royalty("B").place_royalty("W")
  end
  
  def place_pawns(color)
    y = (color == "B") ? 1 : 6
    8.times { |x| Pawn.new([x, y], color, self) }
    
    self
  end
  
  def place_royalty(color)
    y = (color == "B") ? 0 : 7
    royalty = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    8.times { |x| royalty[x].new([x, y], color, self) } 
    
    self
  end
  
  def check?(from, to, color)
    
    #need to deepdup grid and make new board from it to make moves
    new_board = Board.new(dup(@grid))
    new_board.move(from, to)
    
    #find king on new board after move, in case king is the one being moved
    king = new_board.find_king(color)
    
    new_board.grid.each_with_index do |col, y|
      col.each_with_index do |space, x|
        next unless space && space.color != color
        return true if valid_moves([x,y]).include?(king.pos)
      end
    end
    
    false
  end
  
  def checkmate?(color)
    king = find_king(color)
    valid_moves(king.pos).each do |move|
      return false unless check?(king.pos, move, color)
    end
    
    return true
  end
  
  def find_king(color)
    grid.each do |col|
      col.each do |space|
        return space if space.is_a?(King) && space.color == color
      end
    end
  end
  
  def dup
    pieces.each
  end
  
  def pieces
    grid.flatten.compact
  end
  
  def can_move_from?(color, pos)
    has_piece_at?(color, pos) && has_moves_from?(pos)
  end
  
  def can_move_to?(from, to)
    valid_moves(from).include?(to)
  end
  
  def move(from, to)
    self[from].pos = to
    self[to], self[from] = self[from], nil
  end
  
  def has_piece_at?(color, pos)
    !!(self[pos] && self[pos].color == color)
  end
  
  def has_moves_from?(pos)
    valid_moves(pos).length > 0
  end
  
  def valid_moves(pos)
    piece = self[pos]
    return pawn_valid_moves(piece) if piece.class == Pawn
    
    valid_moves = piece.moves.map do |vector|
      available = vector.take_while { |coord| !self[coord] }
      unavailable = vector.drop_while { |coord| !self[coord]}
      
      #may need to add first unavailable location as long as it's an opposing piece
      available.push(unavailable.shift) if unavailable.first && self[unavailable.first].color != piece.color
      available
    end
    
    valid_moves.reject { |vector| vector.length == 0 }.flatten(1)
  end
  
  def pawn_valid_moves(pawn)
    attacking, moving = pawn.moves.partition { |move| move[0] != pawn.pos[0] }
    attacking = attacking.keep_if { |move| self[move] && self[move].color != pawn.color }
    moving = moving.reject { |move| self[move] }
    
    moving.concat(attacking)
  end
  
  def [](pos)
    x, y = pos
    @grid[y][x]
  end
  
  def []=(pos, mark)
    x, y = pos
    @grid[y][x] = mark
  end
  
  def inspect
    display
  end
  
  def display
    puts render
  end
  
  def render
    render_string = "   A  B  C  D  E  F  G  H \n"
    
    grid.each_with_index do |row, y|
      render_string += "#{y} "
      row.each_with_index do |col, x|
        string = grid[y][x] ? " #{grid[y][x].symbol} " : "   "
        render_string += (y + x).even? ? string.on_light_black : string.on_white
      end
      render_string += "\n"
    end
    
    render_string
  end
end