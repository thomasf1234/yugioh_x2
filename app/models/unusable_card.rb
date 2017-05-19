module YugiohX2
  class UnusableCard < ActiveRecord::Base
    validates_presence_of :db_name, :reason
  end
end
