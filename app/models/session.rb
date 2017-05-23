require 'securerandom'

module YugiohX2
  class Session < ActiveRecord::Base
    validates_presence_of :user_id, :uuid, :remote_ip

    before_validation(on: :create) do
      if self.uuid.nil?
        self.uuid = SecureRandom.uuid
      end
    end

    belongs_to :user

    def expired?
      expires_at <= DateTime.now
    end
  end
end
