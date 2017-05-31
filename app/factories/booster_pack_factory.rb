module YugiohX2
  class BoosterPackFactory
    def initialize(booster_pack)
      @booster_pack = booster_pack
    end

    def build
      booster_pack_cards = @booster_pack.cards

      #common_cards
      common_sea = []
      booster_pack_cards.reject(&:rare?).each do |bp_card|
        max_rarity_ratio = BoosterPackCard::Rarities::RATIOS[BoosterPackCard::Rarities::SUPER_SHORT_PRINT]
        (max_rarity_ratio.to_f/bp_card.rarity_ratio).to_i.times do
          common_sea << bp_card
        end
      end


      #rare_cards
      rare_sea = []
      booster_pack_cards.select(&:rare?).each do |bp_card|
        max_rarity_ratio = BoosterPackCard::Rarities::RATIOS[BoosterPackCard::Rarities::GHOST_RARE]
        (max_rarity_ratio.to_f/bp_card.rarity_ratio).to_i.times do
          rare_sea << bp_card
        end
      end


      pack = common_sea.sample(4) << rare_sea.sample
      pack
    end

    def percentage_of_rarities
      rarities = @booster_pack.cards.map(&:rarity).uniq
      rarities.each do |rarity|
        percentage = percentage_of_finding_rarity(rarity)

        puts "#{rarity} : #{percentage}"
      end
    end

    #percentage of finding the passed card
    def percentage_of_finding_card(card, sample_size=10)
      sample = sample_size.times.map { open_until_find_card(card) }
      average = YugiohX2Lib::Utils.average(sample)
      "%.2f%" % (100.0/average)
    end

    def percentage_of_finding_rarity(rarity, sample_size=10)
      sample = sample_size.times.map { open_until_find_rarity(rarity) }
      average = YugiohX2Lib::Utils.average(sample)
      "%.2f%" % (100.0/average)
    end

    #returns pack count
    def open_until_find_card(card)
      i = 0
      content = nil
      until !content.nil? && content.map(&:card_id).include?(card.id)
        content = build
        i += 1
      end
      i
    end

    def open_until_find_rarity(rarity)
      i = 0
      content = nil
      until !content.nil? && content.map(&:rarity).include?(rarity)
        content = build
        i += 1
      end
      i
    end
  end
end