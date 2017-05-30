require 'spec_helper'

module YugiohX2Spec
  module CardsControllerSpec
    RSpec.describe YugiohX2::CardsController do
      before :each do
        FactoryGirl.create(:normal_card)
        FactoryGirl.create(:fusion_card)
        FactoryGirl.create(:spell_card)
      end

      describe "#db_names" do
        let(:get_response) { controller.db_names(request) }
        let(:controller) { YugiohX2::CardsController.new }
        let(:request) { double("Request", query: query, remote_ip: '127.0.0.1') }
        let(:query) { {} }

        it "returns the complete list of db_names" do
          json, response_code = get_response
          expect(response_code).to eq(200)
          expect(JSON.parse(json)['db_names']).to match_array(["Dark_Magician", "Five-Headed_Dragon", "Monster_Reborn"])
        end
      end

      describe "#get" do
        let(:get_response) { controller.get(request) }
        let(:controller) { YugiohX2::CardsController.new }
        let(:request) { double("Request", query: query, remote_ip: '127.0.0.1') }

        context 'Dark_Magician' do
          let(:query) { {'db_name' => 'Dark_Magician'} }
          let(:expected_response) do
            {"card"=>
                 {"db_name"=>"Dark_Magician",
                  "card_type"=>"Monster",
                  "category"=>"Normal",
                  "name"=>"Dark Magician",
                  "level"=>7,
                  "rank"=>nil,
                  "pendulum_scale"=>nil,
                  "card_attribute"=>"DARK",
                  "property"=>nil,
                  "attack"=>"2500",
                  "defense"=>"2100",
                  "serial_number"=>"46986414",
                  "description"=>"The ultimate wizard in terms of attack and defense."},
             "monster_types"=>[],
             "artworks"=>[]}
          end

          it "returns a hash of the card data" do
            json, response_code = get_response
            expect(response_code).to eq(200)
            hash = JSON.parse(json)

            expect(hash.keys).to match_array(['card', 'artworks', 'monster_types'])
            expect(hash['card']).to eq(expected_response['card'])
            expect(hash['monster_types']).to match_array(expected_response['monster_types'])
            expect(hash['artworks']).to match_array(expected_response['artworks'])
          end
        end

        context 'Five-Headed_Dragon' do
          let(:query) { {'db_name' => 'Five-Headed_Dragon'} }
          let(:expected_response) do
            {"card"=>
                 {"db_name"=>"Five-Headed_Dragon",
                  "card_type"=>"Monster",
                  "category"=>"Fusion",
                  "name"=>"Five-Headed Dragon",
                  "level"=>12,
                  "rank"=>nil,
                  "pendulum_scale"=>nil,
                  "card_attribute"=>"DARK",
                  "property"=>nil,
                  "attack"=>"5000",
                  "defense"=>"5000",
                  "serial_number"=>"99267150",
                  "description"=>
                      "5 Dragon-Type monsters\n" +
                          "Must be Fusion Summoned, and cannot be Special Summoned by other ways. Cannot be destroyed by battle with a DARK, EARTH, WATER, FIRE, or WIND monster."},
             "monster_types"=>[],
             "artworks"=>[]}
          end

          it "returns a hash of the card data" do
            json, response_code = get_response
            expect(response_code).to eq(200)
            hash = JSON.parse(json)

            expect(hash.keys).to match_array(['card', 'artworks', 'monster_types'])
            expect(hash['card']).to eq(expected_response['card'])
            expect(hash['monster_types']).to match_array(expected_response['monster_types'])
            expect(hash['artworks']).to match_array(expected_response['artworks'])
          end
        end

        context 'Monster_Reborn' do
          let(:query) { {'db_name' => 'Monster_Reborn'} }
          let(:expected_response) do
            {"card"=>
                 {"db_name"=>"Monster_Reborn",
                  "card_type"=>"NonMonster",
                  "category"=>"Spell",
                  "name"=>"Monster Reborn",
                  "level"=>nil,
                  "rank"=>nil,
                  "pendulum_scale"=>nil,
                  "card_attribute"=>nil,
                  "property"=>"Normal",
                  "attack"=>nil,
                  "defense"=>nil,
                  "serial_number"=>"83764718",
                  "description"=>"Target 1 monster in either player's Graveyard; Special Summon it."},
             "monster_types"=>[],
             "artworks"=>[]}
          end

          it "returns a hash of the card data" do
            json, response_code = get_response
            expect(response_code).to eq(200)
            hash = JSON.parse(json)

            expect(hash.keys).to match_array(['card', 'artworks', 'monster_types'])
            expect(hash['card']).to eq(expected_response['card'])
            expect(hash['monster_types']).to match_array(expected_response['monster_types'])
            expect(hash['artworks']).to match_array(expected_response['artworks'])
          end
        end
      end
    end
  end
end
