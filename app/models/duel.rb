module YugiohX2
  class Duel < ActiveRecord::Base
    validates_presence_of :user_a_id

    def user_a
      YugiohX2::User.find(user_a_id)
    end
    
    def user_b
      YugiohX2::User.find(user_b_id)
    end

    def pending?
      self.state == 'pending'
    end

    def started?
      self.state == 'started'
    end
  end
end
