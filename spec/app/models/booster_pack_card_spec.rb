require 'spec_helper'

module YugiohX2Spec
  module BoosterPackCardSpec
    RSpec.describe YugiohX2::BoosterPackCard do
      describe 'validations' do
        [:booster_pack_id, :card_id].each do |attribute|
          context "#{attribute}" do
            it "should be present" do
              booster_pack_card = YugiohX2::BoosterPackCard.new(attribute =>  nil)
              booster_pack_card.valid?
              expect(booster_pack_card.errors[attribute]).to include("can't be blank")
            end
          end
        end

        context "rarity" do
          it "should be present" do
            booster_pack_card = YugiohX2::BoosterPackCard.new(:rarity =>  nil)
            booster_pack_card.valid?
            expect(booster_pack_card.errors[:rarity]).to include(" is not a valid rarity")

            booster_pack_card.rarity = "SomeOtherRarity"
            booster_pack_card.valid?
            expect(booster_pack_card.errors[:rarity]).to include("SomeOtherRarity is not a valid rarity")

            booster_pack_card.rarity = YugiohX2::BoosterPackCard::Rarities::SUPER_RARE
            booster_pack_card.valid?
            expect(booster_pack_card.errors[:rarity].empty?).to eq(true)
          end
        end
      end


      describe "associations" do
        context 'booster_pack' do
          let(:booster_pack) { YugiohX2::BoosterPack.create!(db_name: "Metal_Raiders",
                                                             name: "Metal Raiders",
                                                             image_path: "path/to/image",
                                                             cost: 500) }

          it "has many items" do
            booster_pack_card = YugiohX2::BoosterPackCard.create!(booster_pack_id: booster_pack.id, card_id: 1, rarity: YugiohX2::BoosterPackCard::Rarities::COMMON)

            expect(booster_pack_card.booster_pack).to eq(booster_pack)
          end
        end
      end
    end
  end
end
