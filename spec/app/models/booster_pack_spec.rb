require 'spec_helper'

module YugiohX2Spec
  module BoosterPackSpec
    RSpec.describe YugiohX2::BoosterPack do
      describe 'validations' do
        [:db_name, :name, :image_path].each do |attribute|
          context "#{attribute}" do
            it "should be present" do
              booster_pack = YugiohX2::BoosterPack.new(attribute =>  nil)
              booster_pack.valid?
              expect(booster_pack.errors[attribute]).to include("can't be blank")
            end
          end
        end

        context 'cost' do
          it 'must be an integer greater than 0' do
            booster_pack = YugiohX2::BoosterPack.new(cost: nil)
            booster_pack.valid?
            expect(booster_pack.errors[:cost]).to include("is not a number")

            booster_pack.cost = -2
            booster_pack.valid?
            expect(booster_pack.errors[:cost]).to include("must be greater than or equal to 0")

            booster_pack.cost = 2
            booster_pack.valid?
            expect(booster_pack.errors[:cost].empty?).to eq(true)
          end
        end
      end


      describe "associations" do
        context 'booster_pack_cards' do
          let(:booster_pack) { YugiohX2::BoosterPack.create!(db_name: "Metal_Raiders",
                                                             name: "Metal Raiders",
                                                             image_path: "path/to/image",
                                                             cost: 500) }

          it "has many items" do
            booster_pack_card1 = YugiohX2::BoosterPackCard.create!(booster_pack_id: booster_pack.id, card_id: 1, rarity: YugiohX2::BoosterPackCard::Rarities::COMMON)
            booster_pack_card2 = YugiohX2::BoosterPackCard.create!(booster_pack_id: booster_pack.id, card_id: 2, rarity: YugiohX2::BoosterPackCard::Rarities::RARE)

            expect(booster_pack.cards).to match_array([booster_pack_card1, booster_pack_card2])
          end
        end
      end
    end
  end
end
