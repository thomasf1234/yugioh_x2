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

        context 'dp' do
          it 'must be an integer greater than 0' do
            user = YugiohX2::User.new(dp: nil)
            user.valid?
            expect(user.errors[:dp]).to include("is not a number")

            user.dp = -2
            user.valid?
            expect(user.errors[:dp]).to include("must be greater than or equal to 0")

            user.dp = 2
            user.valid?
            expect(user.errors[:dp].empty?).to eq(true)
          end
        end
      end

      describe "associations" do
        context 'session' do
          let(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: "{SHA256}some_encrypted_password") }

          it "has one session" do
            session = YugiohX2::Session.create(user_id: user.id, remote_ip: '127.0.0.1')
            expect(user.session).to eq(session)
          end
        end

        context "user_card" do
          let(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: "{SHA256}some_encrypted_password") }

          it "has many user_cards" do
            user_card1 = YugiohX2::UserCard.create!(user_id: user.id, card_id: 1, count: 1)
            user_card2 = YugiohX2::UserCard.create!(user_id: user.id, card_id: 2, count: 1)

            expect(user.user_cards).to match_array([user_card1, user_card2])
          end
        end

        context "cards" do
          let(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: "{SHA256}some_encrypted_password") }
          let(:card1) do
            YugiohX2::Card.create(db_name: 'Dark_Magician',
                                  name: 'Dark Magician',
                                  description: 'The ultimate wizard',
                                  category: YugiohX2::Card::Categories::NORMAL,
                                  card_type: YugiohX2::Card::Types::MONSTER)
          end
          let(:card2) do
            YugiohX2::Card.create(db_name: 'Dark_Magician2',
                                  name: 'Dark Magician2',
                                  description: 'The ultimate wizard2',
                                  category: YugiohX2::Card::Categories::NORMAL,
                                  card_type: YugiohX2::Card::Types::MONSTER)
          end


          it "has many cards through users" do
            YugiohX2::UserCard.create!(user_id: user.id, card_id: card1.id, count: 1)
            YugiohX2::UserCard.create!(user_id: user.id, card_id: card2.id, count: 1)

            expect(user.cards).to match_array([card1, card2])
          end
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
