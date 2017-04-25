class Phase
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def run_hooks
    [:on_start].each do |hook|
      interact(hook)
    end
  end

  def interact(hook)
    while true do
      puts "options: 'hand', 'deck', 'next', 'exit'"

      input = $stdin.gets.strip
      #input = Communications::Input.new

      #key_states = input.gets['keys']
      key_states = [input]
      #input.close

      case key_states.first
        when 'h'
          player.hand.each_with_index {|card, index| puts "#{index+1}) #{card.name}"}
        when 'd'
          player.deck.each_with_index {|card, index| puts "#{index+1}) #{card.name}"}
        when 'o'
          puts "options: #{}"
        when 'n'
          break
        when 'exit'
          exit
        else
          puts 'invalid option'
      end
      puts ""
    end
  end
end