module YugiohX2
  class BoosterPack < ActiveRecord::Base
    validates_presence_of :db_name, :name, :image_path
    validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    has_many :booster_pack_cards

    alias_attribute :cards, :booster_pack_cards
  end
end