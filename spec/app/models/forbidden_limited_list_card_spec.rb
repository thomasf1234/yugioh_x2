require 'spec_helper'

module YugiohX2Spec
  module ForbiddenLimitedListCardSpec
    RSpec.describe YugiohX2::ForbiddenLimitedListCard do
      describe 'validations' do
        [:forbidden_limited_list_id, :card_id].each do |attribute|
          context "#{attribute}" do
            it "should be present" do
              forbidden_limited_list_card = YugiohX2::ForbiddenLimitedListCard.new(attribute => nil)
              forbidden_limited_list_card.valid?
              expect(forbidden_limited_list_card.errors[attribute]).to include("can't be blank")
            end
          end
        end

        context "limited_status" do
          it "should be within the expected set" do
            forbidden_limited_list_card = YugiohX2::ForbiddenLimitedListCard.new(:limited_status => nil)
            forbidden_limited_list_card.valid?
            expect(forbidden_limited_list_card.errors[:limited_status]).to include(" is not a valid limited_status")

            forbidden_limited_list_card.limited_status = "SomeOtherRarity"
            forbidden_limited_list_card.valid?
            expect(forbidden_limited_list_card.errors[:limited_status]).to include("SomeOtherRarity is not a valid limited_status")

            forbidden_limited_list_card.limited_status = YugiohX2::ForbiddenLimitedListCard::LimitedStatus::FORBIDDEN
            forbidden_limited_list_card.valid?
            expect(forbidden_limited_list_card.errors[:limited_status].empty?).to eq(true)
          end
        end
      end


      describe "associations" do
        let(:forbidden_limited_list) { YugiohX2::ForbiddenLimitedList.create!(effective_from: Date.parse("1999-01-01")) }
        let(:card) { FactoryGirl.create(:normal_card) }

        it "belongs_to forbidden_limited_list and card" do
          forbidden_limited_list_card = YugiohX2::ForbiddenLimitedListCard.create!(forbidden_limited_list_id: forbidden_limited_list.id,
                                                                                   card_id: card.id,
                                                                                   limited_status: YugiohX2::ForbiddenLimitedListCard::LimitedStatus::SEMI_LIMITED)

          expect(forbidden_limited_list_card.card).to eq(card)
          expect(forbidden_limited_list_card.forbidden_limited_list).to eq(forbidden_limited_list)
        end
      end
    end
  end
end
