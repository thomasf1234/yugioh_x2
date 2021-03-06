require 'spec_helper'
require 'fileutils'

module YugiohX2Spec
  module SyncBoosterPacksSpec
    class Helper
      def self.run_job(bp_db_name)
        job = YugiohX2Lib::Jobs::SyncBoosterPacks.new
        job.sync(bp_db_name)
      end
    end

    RSpec.describe YugiohX2Lib::Jobs::SyncBoosterPacks do
      shared_examples "synced booster pack" do
        it "syncs the booster pack" do
          #create the cards
          bp_card_data.keys.each do |card_db_name|
            YugiohX2::Card.create!(db_name: card_db_name,
                                   name: "test",
                                   description: "test",
                                   category: YugiohX2::Card::Categories::NORMAL,
                                   card_type: YugiohX2::Card::Types::MONSTER)
          end

          #run job
          Helper.run_job(bp_db_name)

          expect(YugiohX2::BoosterPack.count).to eq(1)
          booster_pack = YugiohX2::BoosterPack.find_by_db_name(bp_db_name)
          expect(booster_pack.name).to eq(name)
          expect(booster_pack.cost).to eq(300)

          expect(YugiohX2::BoosterPackCard.count).to eq(card_count)
          bp_card_data.each do |card_db_name, rarity|
            card = YugiohX2::Card.find_by_db_name(card_db_name)
            expect(card.nil?).to eq(false)

            bp_card = booster_pack.cards.find_by_card_id(card.id)
            expect(bp_card.nil?).to eq(false)
            expect(bp_card.rarity).to eq(rarity)
          end
        end
      end

      describe '#sync' do
        context 'Metal Raiders' do
          let(:bp_db_name) { 'Metal_Raiders' }
          let(:name) { 'Metal Raiders' }
          let(:card_count) { 144 }
          let(:bp_card_data) do
            {"Gate_Guardian"=>"SecretRare",
             "Feral_Imp"=>"Common",
             "Winged_Dragon,_Guardian_of_the_Fortress_1"=>"Common",
             "Summoned_Skull"=>"UltraRare",
             "Rock_Ogre_Grotto_1"=>"Common",
             "Armored_Lizard"=>"Common",
             "Killer_Needle"=>"Common",
             "Larvae_Moth"=>"Common",
             "Harpie_Lady"=>"Common",
             "Harpie_Lady_Sisters"=>"SuperRare",
             "Kojikocy"=>"Common",
             "Cocoon_of_Evolution"=>"SuperShortPrint",
             "Crawling_Dragon"=>"Common",
             "Armored_Zombie"=>"Common",
             "Mask_of_Darkness"=>"Rare",
             "Doma_The_Angel_of_Silence"=>"Common",
             "White_Magical_Hat"=>"Rare",
             "Big_Eye"=>"Common",
             "B._Skull_Dragon"=>"UltraRare",
             "Masked_Sorcerer"=>"Rare",
             "Roaring_Ocean_Snake"=>"Common",
             "Water_Omotics"=>"Common",
             "Ground_Attacker_Bugroth"=>"Common",
             "Petit_Moth"=>"Common",
             "Elegant_Egotist"=>"Rare",
             "Sanga_of_the_Thunder"=>"SuperRare",
             "Kazejin"=>"SuperRare",
             "Suijin"=>"SuperRare",
             "Mystic_Lamp"=>"ShortPrint",
             "Steel_Scorpion"=>"Common",
             "Ocubeam"=>"Common",
             "Leghul"=>"ShortPrint",
             "Ooguchi"=>"ShortPrint",
             "Leogun"=>"Common",
             "Blast_Juggler"=>"Common",
             "Jinzo_7"=>"ShortPrint",
             "Magician_of_Faith"=>"Rare",
             "Ancient_Elf"=>"Common",
             "Deepsea_Shark"=>"Common",
             "Bottom_Dweller"=>"Common",
             "Destroyer_Golem"=>"Common",
             "Kaminari_Attack"=>"Common",
             "Rainbow_Flower"=>"ShortPrint",
             "Morinphen"=>"Common",
             "Mega_Thunderball"=>"Common",
             "Tongyo"=>"Common",
             "Empress_Judge"=>"Common",
             "Pale_Beast"=>"Common",
             "Electric_Lizard"=>"Common",
             "Hunter_Spider"=>"Common",
             "Ancient_Lizard_Warrior"=>"Common",
             "Queen%27s_Double"=>"ShortPrint",
             "Trent"=>"Common",
             "Disk_Magician"=>"Common",
             "Hyosube"=>"Common",
             "Hibikime"=>"Common",
             "Fake_Trap"=>"Rare",
             "Tribute_to_The_Doomed"=>"SuperRare",
             "Soul_Release"=>"Common",
             "The_Cheerful_Coffin"=>"Common",
             "Change_of_Heart"=>"UltraRare",
             "Baby_Dragon"=>"ShortPrint",
             "Blackland_Fire_Dragon"=>"Common",
             "Swamp_Battleguard"=>"Common",
             "Battle_Steer"=>"Common",
             "Time_Wizard"=>"UltraRare",
             "Saggi_the_Dark_Clown"=>"Common",
             "Dragon_Piper"=>"Common",
             "Illusionist_Faceless_Mage"=>"Common",
             "Sangan"=>"Rare",
             "Great_Moth"=>"Rare",
             "Kuriboh"=>"SuperRare",
             "Jellyfish"=>"Common",
             "Castle_of_Dark_Illusions"=>"Common",
             "King_of_Yamimakai"=>"Common",
             "Catapult_Turtle"=>"SuperRare",
             "Mystic_Horseman"=>"Common",
             "Rabid_Horseman"=>"Common",
             "Crass_Clown"=>"ShortPrint",
             "Pumpking_the_King_of_Ghosts"=>"Common",
             "Dream_Clown"=>"ShortPrint",
             "Tainted_Wisdom"=>"Common",
             "Ancient_Brain"=>"Common",
             "Guardian_of_the_Labyrinth"=>"Common",
             "Prevent_Rat"=>"Common",
             "The_Little_Swordsman_of_Aile"=>"Common",
             "Princess_of_Tsurugi"=>"Rare",
             "Protector_of_the_Throne"=>"Common",
             "Tremendous_Fire"=>"Common",
             "Jirai_Gumo"=>"Common",
             "Shadow_Ghoul"=>"Rare",
             "Labyrinth_Tank"=>"Common",
             "Ryu-Kishin_Powered"=>"Common",
             "Bickuribox"=>"Common",
             "Giltia_the_D._Knight"=>"Common",
             "Launcher_Spider"=>"Common",
             "Giga-Tech_Wolf"=>"Common",
             "Thunder_Dragon"=>"ShortPrint",
             "7_Colored_Fish"=>"Common",
             "The_Immortal_of_Thunder"=>"Common",
             "Punished_Eagle"=>"Common",
             "Insect_Soldiers_of_the_Sky"=>"Common",
             "Hoshiningen"=>"Rare",
             "Musician_King"=>"Common",
             "Yado_Karu"=>"Common",
             "Cyber_Saurus"=>"Common",
             "Cannon_Soldier"=>"Rare",
             "Muka_Muka"=>"Rare",
             "The_Bistro_Butcher"=>"Common",
             "Star_Boy"=>"Rare",
             "Milus_Radiant"=>"Rare",
             "Flame_Cerebrus"=>"Common",
             "Niwatori"=>"Common",
             "Dark_Elf"=>"Rare",
             "Mushroom_Man_2"=>"Common",
             "Lava_Battleguard"=>"Common",
             "Witch_of_the_Black_Forest"=>"Rare",
             "Little_Chimera"=>"Rare",
             "Bladefly"=>"Rare",
             "Lady_of_Faith"=>"Common",
             "Twin-Headed_Thunder_Dragon"=>"SuperRare",
             "Witch%27s_Apprentice"=>"Rare",
             "Blue-Winged_Crown"=>"Common",
             "Skull_Knight"=>"Common",
             "Gazelle_the_King_of_Mythical_Beasts"=>"SuperShortPrint",
             "Garnecia_Elefantis"=>"SuperRare",
             "Barrel_Dragon"=>"UltraRare",
             "Solemn_Judgment"=>"UltraRare",
             "Magic_Jammer"=>"UltraRare",
             "Seven_Tools_of_the_Bandit"=>"UltraRare",
             "Horn_of_Heaven"=>"UltraRare",
             "Shield_%26_Sword"=>"Rare",
             "Sword_of_Deep-Seated"=>"Common",
             "Block_Attack"=>"Common",
             "The_Unhappy_Maiden"=>"ShortPrint",
             "Robbin%27_Goblin"=>"Rare",
             "Germ_Infection"=>"Common",
             "Paralyzing_Potion"=>"Common",
             "Mirror_Force"=>"UltraRare",
             "Ring_of_Magnetism"=>"Common",
             "Share_the_Pain"=>"Common",
             "Stim-Pack"=>"ShortPrint",
             "Heavy_Storm"=>"SuperRare",
             "Thousand_Dragon"=>"SecretRare"}
          end

          it_behaves_like "synced booster pack"
        end

        context 'Stardust Overdrive' do
          let(:bp_db_name) { 'Stardust_Overdrive' }
          let(:name) { 'Stardust Overdrive' }
          let(:card_count) { 100 }
          let(:bp_card_data) do
            {"Koa%27ki_Meiru_Beetle"=>"SuperRare",
             "Majestic_Dragon"=>"SuperRare",
             "Stardust_Xiaolong"=>"Rare",
             "Max_Warrior"=>"SuperRare",
             "Quickdraw_Synchron"=>"Common",
             "Level_Eater"=>"Common",
             "Zero_Gardna"=>"Rare",
             "Regulus"=>"Common",
             "Infernity_Necromancer"=>"Common",
             "Fortune_Lady_Wind"=>"Rare",
             "Fortune_Lady_Water"=>"Rare",
             "Fortune_Lady_Dark"=>"Rare",
             "Fortune_Lady_Earth"=>"Rare",
             "Solitaire_Magician"=>"Common",
             "Catoblepas_and_the_Witch_of_Fate"=>"Rare",
             "Dark_Spider"=>"Common",
             "Ground_Spider"=>"Common",
             "Relinquished_Spider"=>"Common",
             "Spyder_Spider"=>"Common",
             "Mother_Spider"=>"Rare",
             "Reptilianne_Gorgon"=>"Common",
             "Reptilianne_Medusa"=>"Common",
             "Reptilianne_Scylla"=>"Common",
             "Reptilianne_Viper"=>"Common",
             "Earthbound_Immortal_Ccarayhua"=>"UltraRare",
             "Earthbound_Immortal_Uru"=>"UltraRare",
             "Earthbound_Immortal_Wiraqocha_Rasca"=>"UltraRare",
             "Koa%27ki_Meiru_Sea_Panther"=>"Common",
             "Koa%27ki_Meiru_Rooklord"=>"SuperRare",
             "Tuned_Magician"=>"Common",
             "Crusader_of_Endymion"=>"UltraRare",
             "Woodland_Archer"=>"Common",
             "Knight_of_the_Red_Lotus"=>"SuperRare",
             "Energy_Bravery"=>"Common",
             "Swap_Frog"=>"Common",
             "Lord_British_Space_Fighter"=>"Rare",
             "Oshaleon"=>"ShortPrint",
             "Djinn_Releaser_of_Rituals"=>"Rare",
             "Djinn_Presider_of_Rituals"=>"Rare",
             "Divine_Grace_-_Northwemko"=>"UltraRare",
             "Majestic_Star_Dragon"=>"UltraRare",
             "Blackwing_-_Silverwind_the_Ascendant"=>"UltraRare",
             "Reptilianne_Hydra"=>"SuperRare",
             "Black_Brutdrago"=>"SuperRare",
             "Explosive_Magician"=>"UltraRare",
             "Spider_Web"=>"Common",
             "Earthbound_Whirlwind"=>"SuperRare",
             "Savage_Colosseum"=>"Common",
             "Attack_Pheromones"=>"Common",
             "Molting_Escape"=>"Common",
             "Reptilianne_Spawn"=>"Common",
             "Fortune%27s_Future"=>"SuperRare",
             "Time_Passage"=>"Common",
             "Iron_Core_Armor"=>"Common",
             "Herculean_Power"=>"Common",
             "Gemini_Spark"=>"Common",
             "Ritual_of_Grace"=>"Common",
             "Preparation_of_Rites"=>"SuperRare",
             "Moray_of_Greed"=>"ShortPrint",
             "Spiritual_Forest"=>"Common",
             "Raging_Mad_Plants"=>"Rare",
             "Insect_Neglect"=>"Common",
             "Faustian_Bargain"=>"ShortPrint",
             "Slip_Summon"=>"Common",
             "Synchro_Barrier"=>"Common",
             "Enlightenment"=>"Common",
             "Bending_Destiny"=>"Common",
             "Inherited_Fortune"=>"Rare",
             "Spider_Egg"=>"Common",
             "Wolf_in_Sheep%27s_Clothing"=>"Common",
             "Earthbound_Wave"=>"Common",
             "Roar_of_the_Earthbound"=>"Common",
             "Limit_Impulse"=>"Common",
             "Infernity_Force"=>"Common",
             "Nega-Ton_Corepanel"=>"Rare",
             "Gemini_Counter"=>"Common",
             "Gemini_Booster"=>"Common",
             "Ritual_Buster"=>"Common",
             "Stygian_Dirge"=>"ShortPrint",
             "Seal_of_Wickedness"=>"SuperRare",
             "Appointer_of_the_Red_Lotus"=>"Common",
             "Koa%27ki_Meiru_Maximus"=>"UltraRare",
             "Shire,_Lightsworn_Spirit"=>"SuperRare",
             "Rinyan,_Lightsworn_Rogue"=>"Rare",
             "Yellow_Baboon,_Archer_of_the_Forest"=>"UltraRare",
             "Gemini_Scorpion"=>"Rare",
             "Metabo-Shark"=>"SuperRare",
             "Earthbound_Revival"=>"Rare",
             "Reptilianne_Poison"=>"Rare",
             "Gateway_of_the_Six"=>"SuperRare",
             "Dark_Rabbit"=>"Rare",
             "Shine_Palace"=>"Rare",
             "Dark_Simorgh"=>"SecretRare",
             "Victoria"=>"SecretRare",
             "Ice_Queen"=>"SecretRare",
             "Shutendoji"=>"SecretRare",
             "Archlord_Kristya"=>"SecretRare",
             "Guardian_Eatos"=>"SecretRare",
             "Clear_Vice_Dragon"=>"SecretRare",
             "Clear_World"=>"SecretRare"}
          end

          it_behaves_like "synced booster pack"
        end

        context 'Maximum Crisis' do
          let(:bp_db_name) { 'Maximum_Crisis' }
          let(:name) { 'Maximum Crisis' }
          let(:card_count) { 100 }
          let(:bp_card_data) do
            {"Pendulum_Switch"=>"Rare",
             "Performapal_Sky_Magician"=>"Rare",
             "Performapal_Sky_Pupil"=>"Rare",
             "Performapal_Revue_Dancer"=>"Common",
             "Performapal_U_Go_Golem"=>"Rare",
             "Performapal_Coin_Dragon"=>"Rare",
             "Speedroid_Skull_Marbles"=>"Common",
             "Speedroid_Maliciousmagnet"=>"Common",
             "Speedroid_Rubberband_Plane"=>"Rare",
             "Predaplant_Ophrys_Scorpio"=>"Rare",
             "Predaplant_Darlingtonia_Cobra"=>"Common",
             "Predaplant_Cordyceps"=>"Common",
             "Lyrilusc_-_Cobalt_Sparrow"=>"Common",
             "Lyrilusc_-_Sapphire_Swallow"=>"Common",
             "Lyrilusc_-_Turquoise_Warbler"=>"Common",
             "D/D_Ghost"=>"Common",
             "Double_Resonator"=>"Common",
             "Supreme_King_Gate_Zero"=>"SuperRare",
             "Supreme_King_Gate_Infinity"=>"SuperRare",
             "Supreme_King_Dragon_Darkwurm"=>"Common",
             "Majesty_Maiden,_the_True_Dracocaster"=>"UltraRare",
             "Ignis_Heat,_the_True_Dracowarrior"=>"UltraRare",
             "Dinomight_Knight,_the_True_Dracofighter"=>"UltraRare",
             "Dreiath_III,_the_True_Dracocavalry_General"=>"UltraRare",
             "Master_Peace,_the_True_Dracoslaying_King"=>"SecretRare",
             "Metaltron_XII,_the_True_Dracombatant"=>"SuperRare",
             "Mariamne,_the_True_Dracophoenix"=>"UltraRare",
             "Zoodiac_Kataroost"=>"Common",
             "Phantasm_Spiral_Dragon"=>"Rare",
             "Digital_Bug_LEDybug"=>"Common",
             "Zefraath"=>"SuperRare",
             "Ariel,_Priestess_of_the_Nekroz"=>"Rare",
             "B.E.S._Big_Core_MK-3"=>"Rare",
             "Pendulumucho"=>"SuperRare",
             "Baobaboon"=>"Common",
             "Fire_Cracker"=>"Common",
             "Ash_Blossom_%26_Joyous_Spring"=>"SecretRare",
             "Familiar-Possessed_-_Lyna"=>"ShortPrint",
             "Fairy_Tail_-_Luna"=>"SuperRare",
             "Supreme_King_Z-ARC"=>"SecretRare",
             "Performapal_Gatlinghoul"=>"UltraRare",
             "Lyrilusc_-_Independent_Nightingale"=>"SuperRare",
             "The_Phantom_Knights_of_Cursed_Javelin"=>"SuperRare",
             "Lyrilusc_-_Assembled_Nightingale"=>"SuperRare",
             "Raidraptor_-_Stranger_Falcon"=>"Rare",
             "D/D/D_Stone_King_Darius"=>"Rare",
             "True_King_of_All_Calamities"=>"SuperRare",
             "Zoodiac_Hammerkong"=>"Common",
             "Zoodiac_Chakanine"=>"UltraRare",
             "Magician%27s_Right_Hand"=>"Common",
             "Magician%27s_Left_Hand"=>"Common",
             "Magician%27s_Restage"=>"Rare",
             "Ultra_Polymerization"=>"SecretRare",
             "Dragonic_Diagram"=>"SecretRare",
             "True_Draco_Heritage"=>"UltraRare",
             "Disciples_of_the_True_Dracophoenix"=>"Common",
             "Pacifis,_the_Phantasm_City"=>"Rare",
             "Phantasm_Spiral_Crash"=>"Common",
             "Phantasm_Spiral_Grip"=>"Common",
             "Phantasm_Spiral_Wave"=>"Common",
             "Bug_Signal"=>"Common",
             "Zefra_Providence"=>"Rare",
             "B.E.F._Zelos"=>"Common",
             "Duelist_Alliance_(card)"=>"SecretRare",
             "Set_Rotation"=>"ShortPrint",
             "Break_Away"=>"Common",
             "The_Phantom_Knights_of_Lost_Vambrace"=>"Common",
             "The_Phantom_Knights_of_Wrong_Magnetring"=>"Common",
             "Dark_Contract_with_the_Eternal_Darkness"=>"Rare",
             "True_King%27s_Return"=>"UltraRare",
             "True_Draco_Apocalypse"=>"Common",
             "Zoodiac_Gathering"=>"Common",
             "Phantasm_Spiral_Battle"=>"Rare",
             "Phantasm_Spiral_Power"=>"Common",
             "Phantasm_Spiral_Assault"=>"Common",
             "Prologue_of_the_Destruction_Swordsman"=>"Common",
             "Dinomists_Howling"=>"Common",
             "Zefra_War"=>"Common",
             "Waterfall_of_Dragon_Souls"=>"SuperRare",
             "Unending_Nightmare"=>"SecretRare",
             "Diamond_Duston"=>"ShortPrint",
             "Tornado_Dragon"=>"SecretRare",
             "Subterror_Fiendess"=>"SuperRare",
             "Subterror_Behemoth_Phospheroglacier"=>"Common",
             "Subterror_Behemoth_Speleogeist"=>"Common",
             "Subterror_Final_Battle"=>"Rare",
             "SPYRAL_Sleeper"=>"SuperRare",
             "SPYRAL_GEAR_-_Last_Resort"=>"Rare",
             "SPYRAL_GEAR_-_Fully_Armed"=>"UltraRare",
             "SPYRAL_MISSION_-_Rescue"=>"Common",
             "Gift_Exchange"=>"Common",
             "Kaiser_Sea_Snake"=>"Common",
             "Bujin_Hiruko"=>"Rare",
             "Sylvan_Princessprite"=>"SuperRare",
             "Artifact_Vajra"=>"Common",
             "Mild_Turkey"=>"Common",
             "Ghost_Beef"=>"Common",
             "Vennu,_Bright_Bird_of_Divinity"=>"Common",
             "Primal_Cry"=>"Common",
             "Onikuji"=>"Common"}
          end

          it_behaves_like "synced booster pack"
        end
      end
    end
  end
end


