require_relative "../LIChess"
require_relative "spec_helper"

describe "LIChess" do 
  it "properly decodes the beginning state of the board" do
    string = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
    standard_board = Board.new
    game = LIChessGame.new
    game.decode_piece_string(string)
    
    expect(same(game.board, standard_board)).to be true
  end
  
  it "properly decodes a random state of the board" do
    string = "1r2r2k/1p1n3R/p1qp2pB/6Pn/P1Pp/3B/1P2PQ1K/5R"
    standard = Board.new(false)
    game = LIChessGame.new
    game.decode_piece_string(string)
    
    Rook.new([1,0], "B", standard)
    Rook.new([4,0], "B", standard)
    King.new([7,0], "B", standard)
    Pawn.new([1,1], "B", standard)
    Knight.new([3,1], "B", standard)
    Rook.new([7,1], "W", standard)
    Pawn.new([0,2], "B", standard)
    Queen.new([2,2], "B", standard)
    Pawn.new([3,2], "B", standard)
    Pawn.new([6,2], "B", standard)
    Bishop.new([7,2], "W", standard)
    Pawn.new([6, 3], "W", standard)
    Knight.new([7,3], "B", standard)
    Pawn.new([0,4], "W", standard)
    Pawn.new([2,4], "W", standard)
    Pawn.new([3,4], "B", standard)
    Bishop.new([3,5], "W", standard)
    Pawn.new([1,6], "W", standard)
    Pawn.new([4,6], "W", standard)
    Queen.new([5,6], "W", standard)
    King.new([7,6], "W", standard)
    Rook.new([5,7], "W", standard)
    
    expect(same(game.board, standard)).to be true
  end
end