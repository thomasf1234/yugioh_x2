require 'digest'

class User < ActiveRecord::Base
  validates_presence_of :username, :encrypted_password

  def self.encrypt_password(username, password)
  "{SHA256}#{Digest::SHA256.digest("#{username}:#{password}")}"
  end
end