module YugiohX2
  class ForbiddenLimitedList < ActiveRecord::Base
    validates_presence_of :effective_from

    has_many :forbidden_limited_list_cards, dependent: :destroy

    def self.current
      where("effective_from <= ?", Date.today).order(effective_from: :desc).first
    end

    def max_limit(card_id)
      forbidden_limited_list_card = forbidden_limited_list_cards.find_by_card_id(card_id)

      if forbidden_limited_list_card.nil?
        3
      else
        case forbidden_limited_list_card.limited_status
          when ForbiddenLimitedListCard::LimitedStatus::FORBIDDEN
            0
          when ForbiddenLimitedListCard::LimitedStatus::LIMITED
            1
          when ForbiddenLimitedListCard::LimitedStatus::SEMI_LIMITED
            2
          else
            raise "Unknown limited_status for forbidden_limited_list_card_id: #{forbidden_limited_list_card.id}"
        end
      end
    end
  end
end
