class GameMat
  def initialize
    @data = {}
    #do not restrict number of cards and positions in zone
    [:p1, :p2].each do |player|
      @data[player] = {
          monster_zones: Array.new(5),
          spell_and_trap_zones: Array.new(5),
          graveyard: [],
          deck_zone: [],
          field_zone: nil,
          extra_deck_zone: [],
          pendulum_zone: nil
      }
    end
  end

  def monster_zone(number, player)
    if number < 1 || number > 5
      raise YugiohError.new("Monster zone must be 1 - 5")
    end
    validate_player(player)

    @data[player][number]
  end

  def spell_and_trap_zone(number, player)
    if number < 1 || number > 5
      raise YugiohError.new("Spell and trap zone must be 1 - 5")
    end
    validate_player(player)

    @data[player][number]
  end

  def graveyard(player)
    validate_player(player)
    @data[player][:graveyard]
  end

  def deck_zone(player)
    validate_player(player)
    @data[player][:deck_zone]
  end

  private
  def validate_player(player)
    if ![:p1, :p2].include?(player)
      raise YugiohError.new("Player must be :p1 or :p2")
    end
  end
end
