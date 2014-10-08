require "net/http"
require "json"

require_relative "Game"

class LIChessGame < Game
  def initialize
    @board = Board.new(false)
    super("Matt", "Anthony", @board)
  end
  
  def setup_board
    pos_string = get_position
    decode_piece_string(pos_string)
    fill_in_captured_pieces(self.player1)
    fill_in_captured_pieces(self.player2)
    self
  end
  
  def get_position
    #GET request for the daily puzzle, parsing the JSON into Ruby Hash
    game = JSON.parse(Net::HTTP.get("en.lichess.org", "/api/puzzle/daily"))
    #Don't care about castling opportunities, move counts etc., just need the first field of the FEN record
    game["position"].split.first
  end
  
  def decode_piece_string(board_state)
    x, y = 0, 0
    board_state.each_char do |char|
      if char == "/" 
        y += 1
        x = 0
        next
      else
        # Could directly cast to integer with Integer(space) but then would have to rescue error for chars
        filler = char.to_i
        filler > 0 ? x += filler - 1 : make_piece([x,y], char)
        #always need to add one to x, so if filler, need to add its value minus one
        x += 1
      end
    end
  end
  
  def make_piece(pos, char) 
    color = char.upcase == char ? "W" : "B"
    #knights represented with n, need Kn for hash
    char = "Kn" if char.downcase == "n"
    class_string = TOKENS[color].keys.select { |key| key.match(/^#{char.capitalize}/)}.first
    #Core equivalent of Rails constantize/classify
    piece = Object.const_get(class_string).new(pos, color, @board)
  end
  
  def fill_in_captured_pieces(player)
    opponent_color = ["W", "B"].select { |char| char != player.color }.first
    piece_symbols = TOKENS[opponent_color]
    original_numbers = {"Queen" => 1, "Rook" => 2, "Knight" => 2, "Bishop" => 2, "Pawn" => 8}
    
    original_numbers.each do |class_string, quantity|
      board_pieces = @board.pieces.select do |piece| 
        piece.class.to_s == class_string && piece.color == opponent_color
      end
      
      captured = quantity - board_pieces.length
      captured.times { player.captured.push(piece_symbols[class_string]) }
    end
  end
end