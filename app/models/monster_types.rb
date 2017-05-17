module YugiohX2
  class MonsterType < ActiveRecord::Base
    belongs_to :card

    validates_presence_of :name, :card_id
  end
end