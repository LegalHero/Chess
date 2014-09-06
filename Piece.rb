class Piece
  def initialize(color)
    self.color = color
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

class Pawn
end