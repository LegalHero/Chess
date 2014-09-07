KNIGHT_DIRS = [[-1,-2],[-1,2],[1,-2],[1,2],[-2,-1],[-2,1],[2,-1],[2,1]]
BISHOP_DIRS = [[-1,-1], [-1,1], [1,-1], [1,1]]
ROOK_DIRS = [[-1,0], [1,0], [0,-1], [0,1]]
#Queen and King dirs are the combination of Bishop and Rook dirs

PAWN_DIRS = [[0,1], [0,2], [-1,1], [1,1]]


class Piece
  attr_accessor :color, :pos
  
  def initialize(pos, color)
    @color = color
    @pos = pos
  end
  
  def moves(total_possible)
    total_possible.select { |move| move.all? { |coord| (0..7).include?(coord) } }
  end
end

class SlidingPiece < Piece
  def moves(dirs)
    total_possible_moves = dirs.map do |dir|
      cardinal = []
      8.times do |n|
        #n + 1 so current position not included (i.e with n = 0)
        #multiply by dir coord to ensure that 0s are never altered
        #add to position to anchor to piece
        dx, dy = (dir[0] * (n + 1) + pos[0]), (dir[1] * (n + 1) + pos[1])
        cardinal.push([dx,dy])
      end
      
      cardinal
    end

    super(total_possible_moves.flatten(1))
  end
end

class SteppingPiece < Piece
  def moves(dirs)
    total_possible_moves = dirs.map do |dir|
      move = [pos[0] + dir[0], pos[1] + dir[1]]
    end
    
    super(total_possible_moves)
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
  
end