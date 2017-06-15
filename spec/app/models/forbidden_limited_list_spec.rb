require 'spec_helper'

module YugiohX2Spec
  module ForbiddenLimitedListSpec
    RSpec.describe YugiohX2::ForbiddenLimitedList do
      describe 'validations' do
        [:effective_from].each do |attribute|
          context "#{attribute}" do
            it "should be present" do
              forbidden_limited_list_card = YugiohX2::ForbiddenLimitedList.new(attribute => nil)
              forbidden_limited_list_card.valid?
              expect(forbidden_limited_list_card.errors[attribute]).to include("can't be blank")
            end
          end
        end
      end


      describe "associations" do
        let(:forbidden_limited_list) { YugiohX2::ForbiddenLimitedList.create!(effective_from: Date.parse("1999-01-01")) }
        let(:forbidden_limited_list_cards) do
          [
              YugiohX2::ForbiddenLimitedListCard.create!(forbidden_limited_list_id: forbidden_limited_list.id,
                                                         card_id: 1,
                                                         limited_status: YugiohX2::ForbiddenLimitedListCard::LimitedStatus::SEMI_LIMITED),
              YugiohX2::ForbiddenLimitedListCard.create!(forbidden_limited_list_id: forbidden_limited_list.id,
                                                         card_id: 2,
                                                         limited_status: YugiohX2::ForbiddenLimitedListCard::LimitedStatus::FORBIDDEN)
          ]
        end

        it "has_many forbidden_limited_list_cards" do
          expect(forbidden_limited_list.forbidden_limited_list_cards).to match_array(forbidden_limited_list_cards)
        end
      end

      describe ".current" do
        before :each do
          today = Date.today

          [today.prev_day, today].each do |date|
            YugiohX2::ForbiddenLimitedList.create!(effective_from: date)
          end
        end

        context "no future lists" do
          it "returns the list that is effective now" do
            expect(YugiohX2::ForbiddenLimitedList.current.effective_from).to eq(Date.today)
          end
        end

        context "future lists" do
          before :each do
            today = Date.today
            YugiohX2::ForbiddenLimitedList.create!(effective_from: today.next_day)
          end

          it "returns the list that is effective now" do
            expect(YugiohX2::ForbiddenLimitedList.current.effective_from).to eq(Date.today)
          end
        end
      end

      describe ".max_limit" do
        before :each do

        end

        context "Unlimited" do

        end
      end
    end
  end
end
