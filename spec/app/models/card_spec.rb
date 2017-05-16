require 'spec_helper'

module YugiohX2Spec
  module CardSpec
    class Helper
      def self.eq?(model, params)
        attributes = (model.attribute_names - ['card_id']).map(&:to_sym)
        attributes.all? do |key|
          model.send(key) == params[key]
        end
      end
    end

    RSpec.describe YugiohX2::Card do
      describe "create" do
        context "Monster" do
          context "Normal" do
            let(:params) do
              {
                  db_name: 'Dark_Magician',
                  card_type: YugiohX2::Card::Types::MONSTER,
                  category: YugiohX2::Card::Categories::NORMAL,
                  name: 'Dark Magician',
                  level: 7,
                  rank: nil,
                  pendulum_scale: nil,
                  card_attribute: YugiohX2::Monster::Elements::DARK,
                  property: nil,
                  attack: '2500',
                  defense: '2100',
                  description: 'The ultimate wizard in terms of attack and defense.',
                  serial_number: '46986414',
              }
            end


            it "creates valid card" do
              expect { YugiohX2::Card.create(params) }.to_not raise_error
              expect(YugiohX2::Card.count).to eq(1)
              expect(YugiohX2::Monster.count).to eq(1)
              expect(YugiohX2::NonMonster.count).to eq(0)

              monster = YugiohX2::Monster.find_by_name(params[:name])
              expect(Helper.eq?(monster, params)).to eq(true)
            end
          end

          context "Effect" do
            let(:params) do
              {
                  db_name: 'Yamata_Dragon',
                  card_type: YugiohX2::Card::Types::MONSTER,
                  category: YugiohX2::Card::Categories::EFFECT,
                  name: 'Yamata Dragon',
                  level: 8,
                  rank: nil,
                  pendulum_scale: nil,
                  card_attribute: YugiohX2::Monster::Elements::FIRE,
                  property: nil,
                  attack: '2600',
                  defense: '3200',
                  description: "This card cannot be Special Summoned. This card returns to its owner's hand during the End Phase of the turn it is Normal Summoned or flipped face-up. When this card inflicts Battle Damage to your opponent, draw cards until you have 5 cards in your hand.",
                  serial_number: '76862289',
              }
            end


            it "creates valid card" do
              expect { YugiohX2::Card.create(params) }.to_not raise_error
              expect(YugiohX2::Card.count).to eq(1)
              expect(YugiohX2::Monster.count).to eq(1)
              expect(YugiohX2::NonMonster.count).to eq(0)

              monster = YugiohX2::Monster.find_by_name(params[:name])
              expect(Helper.eq?(monster, params)).to eq(true)
            end
          end

          context "Xyz" do
            let(:params) do
              {
                  db_name: 'Gem-Knight_Pearl',
                  card_type: YugiohX2::Card::Types::MONSTER,
                  category: YugiohX2::Card::Categories::XYZ,
                  name: 'Gem-Knight Pearl',
                  level: nil,
                  rank: 4,
                  pendulum_scale: nil,
                  card_attribute: YugiohX2::Monster::Elements::EARTH,
                  property: nil,
                  attack: '2600',
                  defense: '1900',
                  description: "2 Level 4 monsters",
                  serial_number: '71594310',
              }
            end


            it "creates valid card" do
              expect { YugiohX2::Card.create(params) }.to_not raise_error
              expect(YugiohX2::Card.count).to eq(1)
              expect(YugiohX2::Monster.count).to eq(1)
              expect(YugiohX2::NonMonster.count).to eq(0)

              monster = YugiohX2::Monster.find_by_name(params[:name])
              expect(Helper.eq?(monster, params)).to eq(true)
            end
          end
        end

        context "Spell" do
          context "Normal" do
            let(:params) do
              {
                  db_name: 'Monster_Reborn',
                  card_type: YugiohX2::Card::Types::NON_MONSTER,
                  category: YugiohX2::Card::Categories::SPELL,
                  name: 'Monster Reborn',
                  level: nil,
                  rank: nil,
                  pendulum_scale: nil,
                  card_attribute: nil,
                  property: YugiohX2::NonMonster::Properties::NORMAL,
                  attack: nil,
                  defense: nil,
                  description: "Target 1 monster in either player's Graveyard; Special Summon it.",
                  serial_number: '83764718'
              }
            end

            it "creates valid card" do
              expect { YugiohX2::Card.create(params) }.to_not raise_error
              expect(YugiohX2::Card.count).to eq(1)
              expect(YugiohX2::Monster.count).to eq(0)
              expect(YugiohX2::NonMonster.count).to eq(1)

              non_monster = YugiohX2::NonMonster.find_by_name(params[:name])
              expect(Helper.eq?(non_monster, params)).to eq(true)
            end
          end
        end
      end
    end
  end
end