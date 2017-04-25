class Zone
  attr_reader :occupant

  def initialize
    @occupant = nil
  end

  def empty?
    @occupant.nil?
  end
end