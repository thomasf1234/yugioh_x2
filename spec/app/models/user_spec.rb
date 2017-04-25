require 'spec_helper'

module UserSpec
  RSpec.describe User do
    describe 'validations' do
      context 'username' do
        it "should be present" do
          user = User.new(username: nil)
          user.valid?
          expect(user.errors[:username]).to include("can't be blank")
        end
      end

      context 'encrypted_password' do
        it "should be present" do
          user = User.new(encrypted_password: nil)
          user.valid?
          expect(user.errors[:encrypted_password]).to include("can't be blank")
        end
      end
    end
  end
end