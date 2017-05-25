require 'spec_helper'

module YugiohX2Spec
  module UserSpec
    RSpec.describe YugiohX2::UserCard do
      describe 'validations' do
        context 'user_id' do
          it "should be present" do
            user = YugiohX2::UserCard.new(user_id: nil)
            user.valid?
            expect(user.errors[:user_id]).to include("can't be blank")
          end
        end

        context 'card_id' do
          it "should be present" do
            user = YugiohX2::UserCard.new(card_id: nil)
            user.valid?
            expect(user.errors[:card_id]).to include("can't be blank")
          end
        end

        context 'count' do
          it 'must be an integer greater than 0' do
            user = YugiohX2::UserCard.new(count: nil)
            user.valid?
            expect(user.errors[:count]).to include("is not a number")

            user.count = -2
            user.valid?
            expect(user.errors[:count]).to include("must be greater than or equal to 0")

            user.count = 2
            user.valid?
            expect(user.errors[:count].empty?).to eq(true)
          end
        end
      end

      describe "associations" do
        let(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: "{SHA256}some_encrypted_password") }

        it "belongs to one user" do
          user_card = YugiohX2::UserCard.create(user_id: user.id, card_id: 1, count: 1)
          expect(user_card.user).to eq(user)
        end
      end


      describe "create" do
        it 'is created with default count 1' do
          user_card = YugiohX2::UserCard.create(user_id: 1, card_id: 1)
          expect(user_card.id).to_not eq(nil)
          expect(user_card.user_id).to eq(1)
          expect(user_card.card_id).to eq(1)
          expect(user_card.count).to eq(1)
        end
      end
    end
  end
end
