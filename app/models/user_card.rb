module YugiohX2
  class UserCard < ActiveRecord::Base
    validates_presence_of :user_id, :card_id
    validates :count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :card_id, uniqueness: { scope: :user_id }

    belongs_to :user
    belongs_to :card

    delegate :db_name, :card_type, :category, :name, :level, :rank, :pendulum_scale,
             :card_attribute, :property, :attack, :defense, :serial_number, :description,
             :artworks, :monster_types,
             to: :card

  end
end
