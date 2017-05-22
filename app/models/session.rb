require 'securerandom'

module YugiohX2
  class Session < ActiveRecord::Base
    validates_presence_of :user_id, :uuid, :remote_ip

    before_validation(on: :create) do
      self.uuid = SecureRandom.uuid
    end

    belongs_to :user
  end
end
