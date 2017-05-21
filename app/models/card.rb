module YugiohX2
  class Card < ActiveRecord::Base
    module Types
      MONSTER = 'Monster'
      NON_MONSTER = 'NonMonster'
      ALL = constants.collect { |const| module_eval(const.to_s) }
    end

    module Categories
      NORMAL = 'Normal'
      EFFECT = 'Effect'
      FUSION = 'Fusion'
      RITUAL = 'Ritual'
      SYNCHRO = 'Synchro'
      XYZ = 'Xyz'
      PENDULUM = 'Pendulum'
      SPELL = 'Spell'
      TRAP = 'Trap'
      ALL = constants.collect { |const| module_eval(const.to_s) }
    end

    validates_presence_of :db_name, :name, :description
    validates :category, inclusion: { in: Categories::ALL, message: "%{value} is not a valid category" }
    validates :card_type, inclusion: { in: Types::ALL, message: "%{value} is not a valid card_type" }

    has_many :artworks, dependent: :destroy
    has_many :monster_types, foreign_key: 'card_id', dependent: :destroy
  end
end
