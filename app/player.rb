class Player
  attr_accessor :hand, :deck, :life_points, :name

  def initialize(name, deck)
    @name = name
    @deck = deck
    @hand = []
  end

  def draw(n=1)
    if n < 1 || n > @deck.size
      raise YugiohError.new("Must draw within 1-current deck size")
    end

    n.times do
      throw(:duel_end, "player '#{name}' LOST; ran out of cards") if @deck.empty?
      @hand << @deck.shift
    end
  end

  def shuffle_deck
    deck.shuffle!
  end
end
