module YugiohX2
  class BoosterPackCard < ActiveRecord::Base
    module Rarities
      COMMON = 'Common'
      NORMAL_RARE = 'NormalRare'
      NORMAL_PARALLEL_RARE = 'NormalParallelRare'
      SHORT_PRINT = 'ShortPrint'
      SUPER_SHORT_PRINT = 'SuperShortPrint'
      RARE = 'Rare'
      SUPER_RARE = 'SuperRare'
      ULTRA_RARE = 'UltraRare'
      ULTRA_PARALLEL_RARE = 'UltraParallelRare'
      ULTIMATE_RARE = 'UltimateRare'
      SECRET_RARE = 'SecretRare'
      HOLOGRAPHIC_RARE = 'HolographicRare'
      GHOST_RARE = 'GhostRare'
      ALL = constants.collect { |const| module_eval(const.to_s) }

      RATIOS = {
          #4 common cards in a pack
          COMMON => 1,
          NORMAL_RARE => 30,
          NORMAL_PARALLEL_RARE => 30,
          SHORT_PRINT => 30,
          SUPER_SHORT_PRINT => 60,

          #1 rare card in a pack
          RARE => 1,
          SUPER_RARE => 6, #1 in 10 packs
          ULTRA_RARE => 12, #1 in 27 packs
          ULTRA_PARALLEL_RARE => 18,
          ULTIMATE_RARE => 24,
          SECRET_RARE => 30, #1 in 300 packs
          HOLOGRAPHIC_RARE => 60,
          GHOST_RARE => 60
      }
    end

    validates_presence_of :card_id, :booster_pack_id
    validates :rarity, inclusion: { in: Rarities::ALL, message: "%{value} is not a valid rarity" }

    belongs_to :booster_pack
    belongs_to :card

    def rarity_ratio
      Rarities::RATIOS[rarity]
    end

    def rare?
      [
          Rarities::RARE,
          Rarities::SUPER_RARE,
          Rarities::ULTRA_RARE,
          Rarities::ULTRA_PARALLEL_RARE,
          Rarities::ULTIMATE_RARE,
          Rarities::SECRET_RARE,
          Rarities::HOLOGRAPHIC_RARE,
          Rarities::GHOST_RARE
      ].include?(rarity)
    end
  end
end