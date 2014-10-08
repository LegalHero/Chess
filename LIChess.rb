require_relative "Game"
require "net/http"
require "json"

class LIChessGame
  def initialize
    @board = Board.new(false)
    @game = Game.new("Matt", "Anthony", @board)
  end
  
  def get_position
    game = JSON.parse(Net::HTTP.get("en.lichess.org", "/api/puzzle/daily"))
    piece_string = game["position"].split.first
    decode_piece_string(piece_string)
  end
end

puts LIChessGame.new.get_position