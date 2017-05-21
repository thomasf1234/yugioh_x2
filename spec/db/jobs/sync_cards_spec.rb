require 'spec_helper'
require 'fileutils'

module YugiohX2Spec
  class Helper
    def self.run_job(card_db_name)
      FileUtils.rm_rf("db/data/test/artworks/#{card_db_name}")

      job = YugiohX2Lib::Jobs::SyncCards.new
      job.sync(card_db_name)
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

      context 'Effect Monster' do
        context 'Effect' do
          let(:card_db_name) { "Van'Dalgyon_the_Dark_Dragon_Lord" }
          let(:expected_description) do
            <<EOF
If you negate the activation of an opponent's Spell/Trap Card(s), or opponent's monster effect(s), with a Counter Trap Card (except during the Damage Step): You can Special Summon this card from your hand. If Summoned this way, activate these effects and resolve in sequence, depending on the type of card(s) negated by that Counter Trap:
● Spell: Inflict 1500 damage to your opponent.
● Trap: Target 1 card your opponent controls; destroy that target.
● Monster: Target 1 monster in your Graveyard; Special Summon it.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(1)
            expect(YugiohX2::MonsterType.count).to eq(2)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(card.name).to eq("Van'Dalgyon the Dark Dragon Lord")
            expect(card.level).to eq(8)
            expect(card.rank).to eq(nil)
            expect(card.pendulum_scale).to eq(nil)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(card.attack).to eq('2800')
            expect(card.defense).to eq('2500')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('24857466')
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                                  YugiohX2::Card::Categories::EFFECT])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/VanDalgyontheDarkDragonLord-TF04-JP-VG.jpg"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Fusion Monster' do
        context 'Effect' do
          let(:card_db_name) { "Five-Headed_Dragon" }
          let(:expected_description) do
            <<EOF
5 Dragon-Type monsters
Must be Fusion Summoned, and cannot be Special Summoned by other ways. Cannot be destroyed by battle with a DARK, EARTH, WATER, FIRE, or WIND monster.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(2)
            expect(YugiohX2::MonsterType.count).to eq(3)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::FUSION)
            expect(card.name).to eq("Five-Headed Dragon")
            expect(card.level).to eq(12)
            expect(card.rank).to eq(nil)
            expect(card.pendulum_scale).to eq(nil)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(card.attack).to eq('5000')
            expect(card.defense).to eq('5000')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('99267150')
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                                   YugiohX2::Card::Categories::FUSION,
                                                                   YugiohX2::Card::Categories::EFFECT])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/FiveHeadedDragon-TF04-JP-VG.png",
                                                "db/data/test/artworks/#{card_db_name}/FiveHeadedDragon-OW.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Ritual Monster' do
        context 'Normal' do
          let(:card_db_name) { "Magician_of_Black_Chaos" }
          let(:expected_description) do
            <<EOF
You can Ritual Summon this card with "Black Magic Ritual".
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(2)
            expect(YugiohX2::MonsterType.count).to eq(2)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::RITUAL)
            expect(card.name).to eq("Magician of Black Chaos")
            expect(card.level).to eq(8)
            expect(card.rank).to eq(nil)
            expect(card.pendulum_scale).to eq(nil)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(card.attack).to eq('2800')
            expect(card.defense).to eq('2600')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('30208479')
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::SPELLCASTER,
                                                                   YugiohX2::Card::Categories::RITUAL])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/MagicianofBlackChaos-TF04-JP-VG.jpg",
                                                "db/data/test/artworks/#{card_db_name}/MagicianofBlackChaos-OW.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Synchro Monster' do
        context 'Effect' do
          let(:card_db_name) { "Stardust_Dragon" }
          let(:expected_description) do
            <<EOF
1 Tuner + 1 or more non-Tuner monsters
During either player's turn, when a card or effect is activated that would destroy a card(s) on the field: You can Tribute this card; negate the activation, and if you do, destroy it. During the End Phase, if this effect was activated this turn (and was not negated): You can Special Summon this card from your Graveyard.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(2)
            expect(YugiohX2::MonsterType.count).to eq(3)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::SYNCHRO)
            expect(card.name).to eq("Stardust Dragon")
            expect(card.level).to eq(8)
            expect(card.rank).to eq(nil)
            expect(card.pendulum_scale).to eq(nil)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::WIND)
            expect(card.attack).to eq('2500')
            expect(card.defense).to eq('2000')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('44508094')
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                                   YugiohX2::Card::Categories::SYNCHRO,
                                                                   YugiohX2::Card::Categories::EFFECT])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/StardustDragon-TF04-JP-VG.jpg",
                                                "db/data/test/artworks/#{card_db_name}/StardustDragon-OW.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Xyz Monster' do
        context 'Effect' do
          let(:card_db_name) { "Bahamut_Shark" }
          let(:expected_description) do
            <<EOF
2 Level 4 WATER monsters
Once per turn: You can detach 1 Xyz Material from this card; Special Summon 1 Rank 3 or lower WATER Xyz Monster from your Extra Deck. This card cannot attack for the rest of this turn.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(0)
            expect(YugiohX2::MonsterType.count).to eq(3)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::XYZ)
            expect(card.name).to eq("Bahamut Shark")
            expect(card.level).to eq(nil)
            expect(card.rank).to eq(4)
            expect(card.pendulum_scale).to eq(nil)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::WATER)
            expect(card.attack).to eq('2600')
            expect(card.defense).to eq('2100')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('00440556')
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::SEA_SERPENT,
                                                                   YugiohX2::Card::Categories::XYZ,
                                                                   YugiohX2::Card::Categories::EFFECT])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array([])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Pendulum Monster' do
        context 'Xyz' do
          let(:card_db_name) { "Odd-Eyes_Raging_Dragon" }
          let(:expected_description) do
            <<EOF
Pendulum Effect
 Once per turn, if you have no cards in your other Pendulum Zone: You can place 1 Pendulum Monster from your Deck in your Pendulum Zone.

 Monster Effect
 2 Level 7 Dragon-Type monstersIf you can Pendulum Summon Level 7, you can Pendulum Summon this face-up card in your Extra Deck. If this card in the Monster Zone is destroyed: You can place it in your Pendulum Zone. If this card is Xyz Summoned using an Xyz Monster as Material, it gains these effects.● It can make a second attack during each Battle Phase.● Once per turn: You can detach 1 Xyz Material from it; destroy as many cards your opponent controls as possible, and if you do, this card gains 200 ATK for each, until the end of this turn.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(1)
            expect(YugiohX2::MonsterType.count).to eq(4)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::PENDULUM)
            expect(card.name).to eq("Odd-Eyes Raging Dragon")
            expect(card.level).to eq(nil)
            expect(card.rank).to eq(7)
            expect(card.pendulum_scale).to eq(1)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(card.attack).to eq('3000')
            expect(card.defense).to eq('2500')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('86238081')
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                                   YugiohX2::Card::Categories::EFFECT,
                                                                   YugiohX2::Card::Categories::PENDULUM,
                                                                   YugiohX2::Card::Categories::XYZ])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/OddEyesRagingDragon-OW.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Spell Card' do
        context 'Normal' do
          let(:card_db_name) { "Monster_Reborn" }
          let(:expected_description) do
            <<EOF
Target 1 monster in either player's Graveyard; Special Summon it.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(0)
            expect(YugiohX2::NonMonster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(3)
            expect(YugiohX2::MonsterType.count).to eq(0)

            card = YugiohX2::NonMonster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::SPELL)
            expect(card.name).to eq("Monster Reborn")
            expect(card.property).to eq(YugiohX2::NonMonster::Properties::NORMAL)
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('83764718')

            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/MonsterReborn-OW.png",
                                                "db/data/test/artworks/#{card_db_name}/MonsterReborn-TF04-JP-VG.png",
                                                "db/data/test/artworks/#{card_db_name}/MonsterReborn-TF04-EN-VG.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Trap Card' do
        context 'Counter' do
          let(:card_db_name) { "Solemn_Judgment" }
          let(:expected_description) do
            <<EOF
When a monster would be Summoned, OR a Spell/Trap Card is activated: Pay half your Life Points; negate the Summon or activation, and if you do, destroy that card.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(0)
            expect(YugiohX2::NonMonster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(3)
            expect(YugiohX2::MonsterType.count).to eq(0)

            card = YugiohX2::NonMonster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::TRAP)
            expect(card.name).to eq("Solemn Judgment")
            expect(card.property).to eq(YugiohX2::NonMonster::Properties::COUNTER)
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq('41420027')

            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/SolemnJudgment-OW.png",
                                                "db/data/test/artworks/#{card_db_name}/SolemnJudgment-TF04-EN-VG.png",
                                                "db/data/test/artworks/#{card_db_name}/SolemnJudgment-TF04-JP-VG.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Game only Card' do
        context 'GX only' do
          let(:card_db_name) { "Clear_Vicious_Knight" }
          let(:expected_description) do
            <<EOF
When this card is face-up card on the field, do not treat its Attribute as DARK. While there are monsters on your opponent's field, you can Normal Summon this card with 1 Tribute. If you control no other cards and have no cards in your hand, this card gains ATK equal to the original ATK of the face-up monster with the highest original ATK on your opponent's field.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::NonMonster.count).to eq(0)
            expect(YugiohX2::Artwork.count).to eq(1)
            expect(YugiohX2::MonsterType.count).to eq(2)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(card.name).to eq("Clear Vicious Knight")
            expect(card.level).to eq(7)
            expect(card.rank).to eq(nil)
            expect(card.pendulum_scale).to eq(nil)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(card.attack).to eq('2300')
            expect(card.defense).to eq('1100')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq(nil)
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::WARRIOR,
                                                                   YugiohX2::Card::Categories::EFFECT])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/ClearViciousKnight-GX06-EN-VG.jpg"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end

        context '5D only' do
          let(:card_db_name) { "Ashoka_Pillar" }
          let(:expected_description) do
            <<EOF
When this card is destroyed, takes 2000 points of damage.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::NonMonster.count).to eq(0)
            expect(YugiohX2::Artwork.count).to eq(2)
            expect(YugiohX2::MonsterType.count).to eq(2)

            card = YugiohX2::Monster.find_by_db_name(card_db_name)

            expect(card.db_name).to eq(card_db_name)
            expect(card.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(card.name).to eq("Ashoka Pillar")
            expect(card.level).to eq(3)
            expect(card.rank).to eq(nil)
            expect(card.pendulum_scale).to eq(nil)
            expect(card.card_attribute).to eq(YugiohX2::Monster::Elements::EARTH)
            expect(card.attack).to eq('0')
            expect(card.defense).to eq('2200')
            expect(card.description).to eq(expected_description.strip)
            expect(card.serial_number).to eq(nil)
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::ROCK,
                                                                   YugiohX2::Card::Categories::EFFECT])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/AshokaPillar-TF04-JP-VG.png",
                                                "db/data/test/artworks/#{card_db_name}/AshokaPillar-OW.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Duplicate Name' do
        context 'Different db_name' do
          let(:card_db_name) { 'Dark_Magician_(Arkana)' }
          let(:expected_description) do
            <<EOF
The ultimate wizard in terms of attack and defense.
EOF
          end

          it "should sync" do
            Helper.run_job(card_db_name)

            expect(YugiohX2::Monster.count).to eq(1)
            expect(YugiohX2::Artwork.count).to eq(1)
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
            expect(card.serial_number).to eq('36996508')
            expect(card.monster_types.map(&:name)).to match_array([YugiohX2::Monster::Species::SPELLCASTER])
            image_paths = card.artworks.map(&:image_path)
            expect(image_paths).to match_array(["db/data/test/artworks/#{card_db_name}/DarkMagician-TF05-JP-VG-3.png"])

            #Files are not empty
            image_paths.each do |image_path|
              expect(File.zero?(image_path)).to eq(false)
            end
          end
        end
      end

      context 'Anime Card' do
        let(:card_db_name) { "Advanced_Crystal_Beast_Sapphire_Pegasus" }

        it "skips" do
          expect { Helper.run_job(card_db_name) }.to_not raise_error

          expect(YugiohX2::Monster.count).to eq(0)
          expect(YugiohX2::NonMonster.count).to eq(0)
          expect(YugiohX2::Artwork.count).to eq(0)
          expect(YugiohX2::MonsterType.count).to eq(0)
        end
      end

      context 'Invalid Card' do
        context 'No description' do
          let(:card_db_name) { "3-eyed_Vespider" }

          it "skips" do
            expect { Helper.run_job(card_db_name) }.to_not raise_error

            expect(YugiohX2::Monster.count).to eq(0)
            expect(YugiohX2::NonMonster.count).to eq(0)
            expect(YugiohX2::Artwork.count).to eq(0)
            expect(YugiohX2::MonsterType.count).to eq(0)
          end
        end

        context 'From an old game' do
          let(:card_db_name) { "3-Beckon_to_Darkness" }

          it "skips" do
            expect { Helper.run_job(card_db_name) }.to_not raise_error

            expect(YugiohX2::Monster.count).to eq(0)
            expect(YugiohX2::NonMonster.count).to eq(0)
            expect(YugiohX2::Artwork.count).to eq(0)
            expect(YugiohX2::MonsterType.count).to eq(0)
          end
        end

        context 'no Card Type' do
          let(:card_db_name) { "4-card_draw_combo" }

          it "skips" do
            expect { Helper.run_job(card_db_name) }.to_not raise_error

            expect(YugiohX2::Monster.count).to eq(0)
            expect(YugiohX2::NonMonster.count).to eq(0)
            expect(YugiohX2::Artwork.count).to eq(0)
            expect(YugiohX2::MonsterType.count).to eq(0)
          end
        end
      end
    end
  end
end


