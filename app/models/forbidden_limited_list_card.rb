module YugiohX2
  class ForbiddenLimitedListCard < ActiveRecord::Base
    module LimitedStatus
      FORBIDDEN = 'Forbidden'
      LIMITED = 'Limited'
      SEMI_LIMITED = 'Semi-Limited'
      ALL = constants.collect { |const| module_eval(const.to_s) }
    end

    validates_presence_of :card_id, :forbidden_limited_list_id
    validates :limited_status, inclusion: { in: LimitedStatus::ALL, message: "%{value} is not a valid limited_status" }

    belongs_to :forbidden_limited_list
    belongs_to :card
  end
end
