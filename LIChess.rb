require_relative "Game"
require "net/http"
require "json"

class LIChessGame
  def initialize
    @board = Board.new(false)
    @game = Game.new("Matt", "Anthony", @board)
    get_position
    @game.play
  end
  
  def get_position
    #GET request for the daily puzzle, parsing the JSON into Ruby Hash
    game = JSON.parse(Net::HTTP.get("en.lichess.org", "/api/puzzle/daily"))
    #Don't care about castling opportunities, move counts etc., just need the first field of the FEN record
    pos_string = game["position"].split.first
    decode_piece_string(pos_string)
  end
  
  def decode_piece_string(board_state)
    p board_state
    board_state.split("/").each_with_index do |row, y|
      # I believe rank is the technical term for each row in chess, I don't mean piece rank
      decode_rank(row, y)
    end
  end
  
  def decode_rank(row, y)
    x = 0
    row.each_char do |space|
      # Could directly cast to integer with Integer(space) but then would have to rescue error for chars
      filler = space.to_i
      filler > 0 ? x += filler - 1 : make_piece([x,y], space)
      x += 1
    end
  end
  
  def make_piece(pos, char) 
    color = char.upcase == char ? "W" : "B"
    char = "Kn" if char.downcase == "n"
    class_string = TOKENS[color].keys.select { |key| key.match(/^#{char.capitalize}/)}.first
    piece = Object.const_get(class_string).new(pos, color, @board)
  end
end

LIChessGame.new