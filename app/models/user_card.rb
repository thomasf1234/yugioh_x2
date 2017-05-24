module YugiohX2
  class UserCard < ActiveRecord::Base
    validates_presence_of :user_id, :card_id
    validates :count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :card_id, uniqueness: { scope: :user_id }

    belongs_to :user
  end
end
