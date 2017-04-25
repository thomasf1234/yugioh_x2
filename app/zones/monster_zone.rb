class MonsterZone
  attr_reader :occupant

  module State
    FACE_UP_ATTACK = :face_up_attack
    FACE_UP_DEFENSE = :face_up_defense
    FACE_DOWN_DEFENSE = :face_down_defense
  end

  def initialize
    @occupant = nil
  end

  def empty?
    @occupant.nil?
  end

  def set_face_up_attack(card)
    set_state(card, FACE_UP_ATTACK)
  end

  def set_face_down_defense(card)
    set_state(card, FACE_DOWN_DEFENSE)
  end

  def set_face_up_defense(card)
    set_state(card, FACE_UP_DEFENSE)
  end

  def remove
    @occupant = nil
  end

  private
  def set_state(card, state)
    @occupant = card
    @state = state
  end
end