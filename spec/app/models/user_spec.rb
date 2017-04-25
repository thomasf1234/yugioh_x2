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

    describe ".encrypt_password" do
      let(:encrypted_password) { "{SHA256}#{Digest::SHA256.digest("test_user:test_password")}" }

      it 'returns a one-way encrypted password' do
        expect(User.encrypt_password("test_user", "test_password")).to eq(encrypted_password)
      end
    end
  end
end