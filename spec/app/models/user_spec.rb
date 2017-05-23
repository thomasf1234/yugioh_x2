require 'spec_helper'

module YugiohX2Spec
  module UserSpec
    RSpec.describe YugiohX2::User do
      describe 'validations' do
        context 'username' do
          it "should be present" do
            user = YugiohX2::User.new(username: nil)
            user.valid?
            expect(user.errors[:username]).to include("can't be blank")
          end
        end

        context 'encrypted_password' do
          it "should be present" do
            user = YugiohX2::User.new(encrypted_password: nil)
            user.valid?
            expect(user.errors[:encrypted_password]).to include("can't be blank")
          end
        end
      end

      describe "associations" do
        let(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: "{SHA256}some_encrypted_password") }

        it "has one session" do
          session = YugiohX2::Session.create(user_id: user.id, remote_ip: '127.0.0.1')
          expect(user.session).to eq(session)
        end
      end

      describe ".encrypt_password" do
        let(:encrypted_password) { "{SHA256}#{Digest::SHA256.digest("test_user:test_password")}" }

        it 'returns a one-way encrypted password' do
          expect(YugiohX2::User.encrypt_password("test_user", "test_password")).to eq(encrypted_password)
        end
      end

      describe "create" do
        let(:username) { 'test_user' }
        let(:encrypted_password) { "{SHA256}#{Digest::SHA256.digest("#{username}:test_password")}" }

        it 'is created with default 0 dp' do
          user = YugiohX2::User.create(username: username, encrypted_password: encrypted_password)
          expect(user.id).to_not eq(nil)
          expect(user.username).to eq(username)
          expect(user.encrypted_password).to eq(encrypted_password)
          expect(user.dp).to eq(0)
        end
      end
    end
  end
end
