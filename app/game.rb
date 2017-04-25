class Game
  def start
    require 'pry'; binding.pry
    deck1 = Deck.new(Monster.where(category: "Normal").limit(40).to_a)
    deck2 = Deck.new(Monster.where(category: "Effect").limit(40).to_a)
    player1 = Player.new('Yugi', deck1)
    player2 = Player.new('Seto', deck2)
    game = Duel.new(player1, player2)
    game.start
  end
end