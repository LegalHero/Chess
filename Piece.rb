KNIGHT_DIRS = [[-1,-2],[-1,2],[1,-2],[1,2],[-2,-1],[-2,1],[2,-1],[2,1]]
BISHOP_DIRS = [[-1,-1], [-1,1], [1,-1], [1,1]]
ROOK_DIRS = [[-1,0], [1,0], [0,-1], [0,1]]

#Queen and King dirs are the combination of Bishop and Rook dirs
#Pawn dirs are at most three, but more variable, easier to handle directly in class

class Piece
  def initialize(color)
    @color = color
  end
end

class SlidingPiece < Piece
end

class SteppingPiece < Piece
end

class Queen < SlidingPiece
end

class Bishop < SlidingPiece
end

class Rook < SlidingPiece
end

class King < SteppingPiece
end

class Knight < SteppingPiece
end

class Pawn < Piece
end