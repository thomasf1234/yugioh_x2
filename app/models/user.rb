class User < ActiveRecord::Base
  validates_presence_of :username, :encrypted_password

end