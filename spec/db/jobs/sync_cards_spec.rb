require 'spec_helper'
require 'fileutils'

module YugiohX2Spec
  class Helper
    def self.run_job(card_db_name)
      FileUtils.rm_rf("db/data/test/artworks/#{card_db_name}")

      job = YugiohX2Lib::Jobs::SyncCards.new
      job.sync_card(card_db_name)
    end
  end

  RSpec.describe YugiohX2Lib::Jobs::SyncCards do
    describe 'sync_card' do
      context 'Normal Monster' do
        context 'Normal' do
          let(:card_db_name) { 'Dark_Magician' }
          let(:expected_description) do
            <<EOF
The ultimate wizard in terms of attack and defense.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(8)
            expect(YugiohX2::MonsterType.count).to eq(1)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::NORMAL)
            expect(card.name).to eq('Dark Magician')
            expect(card.level).to eq(7)
            expect(card.rank).to eq(nil)
            expect(card.pendulum_scale).to eq(nil)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(card.attack).to eq('2500')
            expect(card.defense).to eq('2100')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('46986414')
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::SPELLCASTER])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/DarkMagician-OW.png",
                                                "db/data/test/artworks/#{card_db_name}/DarkMagician-OW-2.png",
                                                "db/data/test/artworks/#{card_db_name}/DarkMagician-OW-3.png",
                                                "db/data/test/artworks/#{card_db_name}/DarkMagician-TF05-JP-VG.png",
                                                "db/data/test/artworks/#{card_db_name}/DarkMagician-TF05-JP-VG-2.png",
                                                "db/data/test/artworks/#{card_db_name}/DarkMagician-TF05-JP-VG-3.png",
                                                "db/data/test/artworks/#{card_db_name}/DarkMagician-TF05-JP-VG-4.png",
                                                "db/data/test/artworks/#{card_db_name}/DarkMagician-TF05-JP-VG-5.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end

        context 'Tuner' do
          let(:card_db_name) { 'Ally_Mind' }
          let(:expected_description) do
            <<EOF
A high-performance unit developed to enhance the Artificial Intelligence program of the Allies of Justice. Loaded with elements collected from a meteor found in the Worm Nebula, it allows for highly tuned performance. But its full capacity is not yet determined.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(1)
            expect(YugiohX2::MonsterType.count).to eq(2)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::NORMAL)
            expect(card.name).to eq('Ally Mind')
            expect(card.level).to eq(5)
            expect(card.rank).to eq(nil)
            expect(card.pendulum_scale).to eq(nil)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(card.attack).to eq('1800')
            expect(card.defense).to eq('1400')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('40155554')
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::MACHINE,
                                                                   YugiohX2::Monster::Abilities::TUNER])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/AllyMind-TF04-JP-VG.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end
    end
  end
end


