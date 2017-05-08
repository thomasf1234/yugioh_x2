module YugiohX2
  class Card < ActiveRecord::Base
    module Categories
      NORMAL = 'Normal'
      EFFECT = 'Effect'
      FUSION = 'Fusion'
      RITUAL = 'Ritual'
      SYNCHRO = 'Synchro'
      XYZ = 'Xyz'
      SPELL = 'Spell'
      TRAP = 'Trap'
      ALL = constants.collect { |const| module_eval(const.to_s) }
    end

    has_many :properties, dependent: :destroy

    validates_presence_of :name, :description

    after_initialize :readonly!
  end
end
