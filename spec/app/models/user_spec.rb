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

      describe "#deposit" do
        let(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: "{SHA256}some_encrypted_password") }

        context 'invalid deposit amount' do
          [0, -1, 0.5, '1'].each do |invalid_deposit|
            it 'raises argument error' do
              expect { user.deposit(invalid_deposit) }.to raise_error(ArgumentError, "amount must be a positive integer")
            end
          end
        end

        context 'valid deposit amount' do
          it 'raises the users dp' do
            user.deposit(1)
            expect(user.dp).to eq(1)

            user.deposit(5)
            expect(user.dp).to eq(6)

            user.deposit(50)
            expect(user.dp).to eq(56)
          end
        end
      end

      describe "#withdraw" do
        let(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: "{SHA256}some_encrypted_password", dp: 50) }

        context 'invalid withdrawal amount' do
          [0, -1, 0.5, '1'].each do |invalid_withdrawal|
            it 'raises argument error' do
              expect { user.withdraw(invalid_withdrawal) }.to raise_error(ArgumentError, "amount must be a positive integer")
            end
          end
        end

        context 'valid withdraw amount' do
          context 'not enough dp to satisfy the withdrawl' do
            it "raises ArgumentError and does not update the users dp" do
              expect { user.withdraw(51) }.to raise_error(ArgumentError, "There is not enough dp to make the requested withdrawl")
              user.reload
              expect(user.dp).to eq(50)
            end
          end

          context 'enough dp to satisfy the withdrawal' do
            it 'reduces the users dp' do
              user.withdraw(1)
              expect(user.dp).to eq(49)

              user.withdraw(5)
              expect(user.dp).to eq(44)

              user.withdraw(23)
              expect(user.dp).to eq(21)
            end
          end
        end
      end
    end
  end
end
