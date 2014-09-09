# coding: UTF-8
TOKENS = { "W" => { "King" => "♔" , "Queen" => "♕", "Rook" => "♖", "Bishop" => "♗","Knight" => "♘", "Pawn" => "♙" }, 
           "B" => { "King" => "♚", "Queen" => "♛", "Rook" => "♜", "Bishop" => "♝", "Knight" => "♞", "Pawn" => "♟" } }

KNIGHT_DIRS = [[-1,-2],[-1,2],[1,-2],[1,2],[-2,-1],[-2,1],[2,-1],[2,1]]
BISHOP_DIRS = [[-1,-1], [-1,1], [1,-1], [1,1]]
ROOK_DIRS = [[-1,0], [1,0], [0,-1], [0,1]]
#Queen and King dirs are the combination of Bishop and Rook dirs

PAWN_DIRS = [[0,2], [0,1], [-1,1], [1,1]]


class Piece
  attr_accessor :pos
  attr_reader :symbol, :color
  
  def self.assign_symbol(color, type)
    TOKENS[color][type]
  end
  
  def initialize(pos, color, board)
    @color = color
    @pos = pos
    @symbol = Piece.assign_symbol(@color, self.class.to_s)
    board[pos] = self
  end
  
  def moves(total_possible)
    total = total_possible.select { |move| move.all? { |coord| (0..7).include?(coord) } }
    return nil unless total.length > 0
    total
  end
end

class SlidingPiece < Piece
  def moves(dirs)
    total_possible_moves = dirs.map do |dir|
      vector = []
      8.times do |n|
        #n + 1 so current position not included (i.e with n = 0)
        #multiply by dir coord to ensure that 0s are never altered
        #add to position to anchor to piece
        dx, dy = (dir[0] * (n + 1) + pos[0]), (dir[1] * (n + 1) + pos[1])
        vector.push([dx,dy])
      end
      
      super(vector)
    end
    
    total_possible_moves.compact
  end
end

class SteppingPiece < Piece
  def moves(dirs)
    total_possible_moves = dirs.map do |dir|
      move = [[pos[0] + dir[0], pos[1] + dir[1]]]
      super(move)
    end
    
    total_possible_moves.compact
  end
end

class Queen < SlidingPiece
  def moves
    super(BISHOP_DIRS + ROOK_DIRS)
  end
end

class Bishop < SlidingPiece
  def moves
    super(BISHOP_DIRS)
  end
end

class Rook < SlidingPiece
  def moves
    super(ROOK_DIRS)
  end
end

class King < SteppingPiece
  def moves
    super(BISHOP_DIRS + ROOK_DIRS)
  end
end

class Knight < SteppingPiece
  def moves
    super(KNIGHT_DIRS)
  end
end

class Pawn < Piece
  def moves
    total_possible_moves = PAWN_DIRS.map do |dir|
      dx = dir[0] + pos[0]
      
      #white on the bottom
      dy = (color === "B") ? pos[1] + dir[1] : pos[1] - dir[1] 
      
      move = [dx, dy]
    end
    total_possible_moves = total_possible_moves.drop(1) unless starting_position?
    
    super(total_possible_moves)
  end
  
  def starting_position?
    ((color == "B" && pos[1] == 1) || (color == "W" && pos[1] == 6)) 
  end
end