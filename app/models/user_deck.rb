module YugiohX2
  class UserDeck < ActiveRecord::Base
    serialize :main_card_ids
    serialize :extra_card_ids
    serialize :side_card_ids

    validates_presence_of :user_id
    validates_length_of :main_card_ids, minimum: 40, maximum: 60
    validates_length_of :extra_card_ids, maximum: 15
    validates_length_of :side_card_ids, maximum: 15
    validate :abides_by_rulebook

    private
    def card_ids
      main_card_ids + extra_card_ids + side_card_ids
    end

    #ordered validation
    def abides_by_rulebook
      validate_card_count
      validate_card_category
    end

    def validate_card_count
      current_forbidden_limited_list = ForbiddenLimitedList.current
      grouped_card_ids = card_ids.group_by {|card_id| card_id }
      grouped_card_ids.each do |grouped_card_id, card_ids|
        if YugiohX2::Card.exists?(grouped_card_id)
          max_limit = current_forbidden_limited_list.max_limit(grouped_card_id)
          if card_ids.count > max_limit
            errors.add(:card_id, "More than #{max_limit} copies for id: #{grouped_card_id}")
          end
        else
          errors.add(:card_id, "Card not found for id: #{grouped_card_id}")
        end
      end
    end

    def validate_card_category
      main_card_ids.uniq.each do |card_id|
        card = YugiohX2::Card.find(card_id)

        if !main_deck_categories.include?(card.category)
          errors.add(:main_card_ids, "Non-main deck card found in main_card_ids: #{card_id}")
        end
      end

      extra_card_ids.uniq.each do |card_id|
        card = YugiohX2::Card.find(card_id)

        if !extra_deck_categories.include?(card.category)
          errors.add(:extra_card_ids, "Non-extra deck card found in extra_card_ids: #{card_id}")
        end
      end
    end

    def main_deck_categories
      Card::Categories::ALL - extra_deck_categories
    end

    def extra_deck_categories
      [Card::Categories::FUSION,
       Card::Categories::SYNCHRO,
       Card::Categories::XYZ]
    end

    def side_deck_categories
      Card::Categories::ALL
    end
  end
end
