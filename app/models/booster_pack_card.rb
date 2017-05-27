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
    end

    validates_presence_of :card_id, :booster_pack_id
    validates :rarity, inclusion: { in: Rarities::ALL, message: "%{value} is not a valid rarity" }

    belongs_to :booster_pack
    belongs_to :card
  end
end