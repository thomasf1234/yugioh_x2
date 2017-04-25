class Deck < Array
  MIN = 40
  MAX = 60

  def initialize(cards)
    super(cards)
    if cards.length < MIN || cards.length > MAX
      raise YugiohError.new("Deck size must be 40 to 60")
    end
  end
end