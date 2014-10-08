require_relative "Game"
require "net/http"
require "json"

class LIChessGame
  def initialize
    @board = Board.new(false)
    @game = Game.new("Matt", "Anthony", @board)
    setup_board
    @game.play
  end
  
  def setup_board
    pos_string = get_position
    decode_piece_string(pos_string)
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
end

LIChessGame.new