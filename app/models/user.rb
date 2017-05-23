require 'digest'

module YugiohX2
  class User < ActiveRecord::Base
    validates_presence_of :username, :encrypted_password

    def self.encrypt_password(username, password)
      "{SHA256}#{Digest::SHA256.digest("#{username}:#{password}")}"
    end

    has_one :session

    def deposit(amount)
      if !YugiohX2Lib::Utils.positive_integer?(amount)
        raise ArgumentError.new("amount must be a positive integer")
      else
        new_dp = self.dp + amount
        update_attribute(:dp, new_dp)
        amount
      end
    end

    def withdraw(amount)
      if !YugiohX2Lib::Utils.positive_integer?(amount)
        raise ArgumentError.new("amount must be a positive integer")
      else
        if amount > self.dp
          raise ArgumentError.new("There is not enough dp to make the requested withdrawl")
        else
          new_dp = self.dp - amount
          update_attribute(:dp, new_dp)
          amount
        end
      end
    end
  end
end
