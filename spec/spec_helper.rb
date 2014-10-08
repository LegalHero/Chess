def same(board1, board2)
  board1.pieces.each_with_index do |piece, index|
    return false unless piece.color == board2.pieces[index].color && piece.pos == board2.pieces[index].pos
  end
  
  return true
end