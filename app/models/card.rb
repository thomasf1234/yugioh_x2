module YugiohX2
  class Card < ActiveRecord::Base
    module Types
      MONSTER = 'Monster'
      NON_MONSTER = 'NonMonster'
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

    has_many :properties, dependent: :destroy

    validates_presence_of :name, :description

    after_initialize :readonly!
  end
end
