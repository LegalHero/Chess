require_relative "Piece"
require "colorize"

class Board
  attr_accessor :grid
  
  def self.create_grid
    matrix = Array.new(4) { Array.new(8) }
    matrix.unshift(Board.place_pawns("B")).push(Board.place_pawns("W"))
    matrix.unshift(Board.place_royalty("B")).push(Board.place_royalty("W"))
    
    matrix
  end
  
  def self.place_pawns(color)
    y = (color == "B") ? 1 : 6
    pawns = []
    8.times { |n| pawns.push(Pawn.new([n, y], color)) }
    
    pawns
  end
  
  def self.place_royalty(color)
    y = (color == "B") ? 0 : 7
    
    royalty = [
      Rook.new([0, y], color), 
      Knight.new([1, y], color),
      Bishop.new([2, y], color),
      Queen.new([3, y], color),
      King.new([4, y], color),
      Bishop.new([5, y], color),
      Knight.new([6, y], color),
      Rook.new([7, y], color)]
  end
  
  def initialize
    @grid = Board.create_grid
  end
  
  def [](pos)
    x, y = pos
    @grid[y][x]
  end
  
  def []=(pos, mark)
    x, y = pos
    @grid[y][x] = mark
  end
  
  def can_move_from?(color, pos)
    has_piece_at?(color, pos) && has_moves_from?(pos)
  end
  
  def has_piece_at?(color, pos)
    !!(self[pos] && self[pos].color == color)
  end
  
  def has_moves_from?(pos)
    valid_moves(pos).length > 0
  end
  
  def valid_moves(pos)
    piece = self[pos]
    # return pawn_valid_moves(piece) if piece.class == Pawn
    
    valid_moves = piece.moves.map do |vector|
      available = vector.take_while { |coord| !self[coord] }
      unavailable = vector.drop_while { |coord| !self[coord]}
    
      available.push(unavailable.shift) if unavailable.first && self[unavailable.first].color != piece.color
      available
    end
    
    valid_moves.reject { |vector| vector.length == 0 }
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