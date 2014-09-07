KNIGHT_DIRS = [[-1,-2],[-1,2],[1,-2],[1,2],[-2,-1],[-2,1],[2,-1],[2,1]]
BISHOP_DIRS = [[-1,-1], [-1,1], [1,-1], [1,1]]
ROOK_DIRS = [[-1,0], [1,0], [0,-1], [0,1]]

#Queen and King dirs are the combination of Bishop and Rook dirs
#Pawn dirs are at most three, but more variable, easier to handle directly in class

class Piece
  attr_accessor :color, :pos
  
  def initialize(pos, color)
    @color = color
    @pos = pos
  end
end

class SlidingPiece < Piece
end

class SteppingPiece < Piece
  def moves(dirs)
    total_possible_moves = dirs.map do |dir|
      move = [pos[0] + dir[0], pos[1] + dir[1]]
    end
    
    total_possible_moves.select { |move| move.all? { |coord| (0..7).include?(coord) } }
  end
end

class Queen < SlidingPiece
end

class Bishop < SlidingPiece
end

class Rook < SlidingPiece
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
end