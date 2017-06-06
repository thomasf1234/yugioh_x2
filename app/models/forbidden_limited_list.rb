module YugiohX2
  class ForbiddenLimitedList < ActiveRecord::Base
    validates_presence_of :effective_from

    has_many :forbidden_limited_list_cards, dependent: :destroy

    def self.current
      where("effective_from < ?", Date.today).order(effective_from: :desc).first
    end
  end
end
