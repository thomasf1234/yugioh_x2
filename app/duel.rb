class Duel
  attr_accessor :p1, :p2, :turn

  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
  end

  def start
    [p1, p2].each do |player|
      player.life_points = 8000
      player.shuffle_deck
      player.draw(5)
      @turn = 0
    end

    results = catch(:duel_end) do
      [p1, p2].cycle do |player|
        @turn += 1
        [DrawPhase, StandbyPhase, Main1Phase, EndPhase].each do |phase_klass|
          puts "#turn: #{@turn}, player: #{player.name}, phase: #{phase_klass.name}"
          phase = phase_klass.new(player)
          phase.run_hooks
          puts "###################################################################"
          puts "###################################################################"
        end
      end
    end

    puts "DUEL END!!!!!"
    puts results
  end
end