require 'spec_helper'

module YugiohX2Lib
  RSpec.describe YugiohX2Lib::ExternalPages::MainPage do
    describe 'card_type' do
      let(:main_page) { YugiohX2Lib::ExternalPages::MainPage.new(card_db_name) }

      context 'Normal Monster' do
        let(:card_db_name) { 'Dark_Magician' }
        let(:expected_description) do
          <<EOF
The ultimate wizard in terms of attack and defense.
EOF
        end

        it 'should be Normal' do
          expect(main_page.card_db_name).to eq(card_db_name)
          expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
          expect(main_page.category).to eq(YugiohX2::Card::Categories::NORMAL)
          expect(main_page.card_name).to eq('Dark Magician')
          expect(main_page.level).to eq('7')
          expect(main_page.rank).to eq(nil)
          expect(main_page.pendulum_scale).to eq(nil)
          expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
          expect(main_page.property).to eq(nil)
          expect(main_page.types).to match_array([YugiohX2::Monster::Species::SPELLCASTER])
          expect(main_page.attack).to eq('2500')
          expect(main_page.defense).to eq('2100')
          expect(main_page.card_description).to eq(expected_description.strip)
          expect(main_page.serial_number).to eq('46986414')
        end
      end

      context 'Normal Tuner Monster' do
        let(:card_db_name) { 'Ally_Mind' }
        let(:expected_description) do
          <<EOF
A high-performance unit developed to enhance the Artificial Intelligence program of the Allies of Justice. Loaded with elements collected from a meteor found in the Worm Nebula, it allows for highly tuned performance. But its full capacity is not yet determined.
EOF
        end

        it 'should be Normal Tuner' do
          expect(main_page.card_db_name).to eq(card_db_name)
          expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
          expect(main_page.category).to eq(YugiohX2::Card::Categories::NORMAL)
          expect(main_page.card_name).to eq('Ally Mind')
          expect(main_page.level).to eq('5')
          expect(main_page.rank).to eq(nil)
          expect(main_page.pendulum_scale).to eq(nil)
          expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
          expect(main_page.property).to eq(nil)
          expect(main_page.types).to match_array([YugiohX2::Monster::Species::MACHINE,
                                                  YugiohX2::Monster::Abilities::TUNER])
          expect(main_page.attack).to eq('1800')
          expect(main_page.defense).to eq('1400')
          expect(main_page.card_description).to eq(expected_description.strip)
          expect(main_page.serial_number).to eq('40155554')
        end
      end

      context 'Effect Monster' do
        let(:card_db_name) { "Van'Dalgyon_the_Dark_Dragon_Lord" }
        let(:expected_description) do
          <<EOF
If you negate the activation of an opponent's Spell/Trap Card(s), or opponent's monster effect(s), with a Counter Trap Card (except during the Damage Step): You can Special Summon this card from your hand. If Summoned this way, activate these effects and resolve in sequence, depending on the type of card(s) negated by that Counter Trap:
● Spell: Inflict 1500 damage to your opponent.
● Trap: Target 1 card your opponent controls; destroy that target.
● Monster: Target 1 monster in your Graveyard; Special Summon it.
EOF
        end

        it 'should be Effect' do
          expect(main_page.card_db_name).to eq(card_db_name)
          expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
          expect(main_page.category).to eq(YugiohX2::Card::Categories::EFFECT)
          expect(main_page.card_name).to eq("Van'Dalgyon the Dark Dragon Lord")
          expect(main_page.level).to eq('8')
          expect(main_page.rank).to eq(nil)
          expect(main_page.pendulum_scale).to eq(nil)
          expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
          expect(main_page.property).to eq(nil)
          expect(main_page.types).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                  YugiohX2::Card::Categories::EFFECT])
          expect(main_page.attack).to eq('2800')
          expect(main_page.defense).to eq('2500')
          expect(main_page.card_description).to eq(expected_description.strip)
          expect(main_page.serial_number).to eq('24857466')
        end
      end

      context 'Fusion Monster' do
        let(:card_db_name) { "Black_Skull_Dragon" }
        let(:expected_description) do
          <<EOF
"Summoned Skull" + "Red-Eyes B. Dragon"



(This card is always treated as an "Archfiend" card.)
EOF
        end

        it 'should be Fusion' do
          expect(main_page.card_db_name).to eq(card_db_name)
          expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
          expect(main_page.category).to eq(YugiohX2::Card::Categories::FUSION)
          expect(main_page.card_name).to eq("B. Skull Dragon")
          expect(main_page.level).to eq('9')
          expect(main_page.rank).to eq(nil)
          expect(main_page.pendulum_scale).to eq(nil)
          expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
          expect(main_page.property).to eq(nil)
          expect(main_page.types).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                  YugiohX2::Card::Categories::FUSION])
          expect(main_page.attack).to eq('3200')
          expect(main_page.defense).to eq('2500')
          expect(main_page.card_description).to eq(expected_description.strip)
          expect(main_page.serial_number).to eq('11901678')
        end
      end

      context 'Ritual Monster' do
        let(:card_db_name) { "Relinquished" }
        let(:expected_description) do
          <<EOF
You can Ritual Summon this card with "Black Illusion Ritual". Once per turn: You can target 1 monster your opponent controls; equip that target to this card. (You can only equip 1 monster at a time to this card with this effect.) This card's ATK and DEF become equal to that equipped monster's. If this card would be destroyed by battle, destroy that equipped monster instead. While equipped with that monster, any battle damage you take from battles involving this card inflicts equal effect damage to your opponent.
EOF
        end

        it 'should be Ritual' do
          expect(main_page.card_db_name).to eq(card_db_name)
          expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
          expect(main_page.category).to eq(YugiohX2::Card::Categories::RITUAL)
          expect(main_page.card_name).to eq("Relinquished")
          expect(main_page.level).to eq('1')
          expect(main_page.rank).to eq(nil)
          expect(main_page.pendulum_scale).to eq(nil)
          expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
          expect(main_page.property).to eq(nil)
          expect(main_page.types).to match_array([YugiohX2::Monster::Species::SPELLCASTER,
                                                  YugiohX2::Card::Categories::RITUAL,
                                                  YugiohX2::Card::Categories::EFFECT])
          expect(main_page.attack).to eq('0')
          expect(main_page.defense).to eq('0')
          expect(main_page.card_description).to eq(expected_description.strip)
          expect(main_page.serial_number).to eq('64631466')
        end
      end

      context 'Synchro Monster' do
        let(:card_db_name) { "Stardust_Dragon" }
        let(:expected_description) do
          <<EOF
1 Tuner + 1 or more non-Tuner monsters
During either player's turn, when a card or effect is activated that would destroy a card(s) on the field: You can Tribute this card; negate the activation, and if you do, destroy it. During the End Phase, if this effect was activated this turn (and was not negated): You can Special Summon this card from your Graveyard.
EOF
        end

        it 'should be Synchro' do
          expect(main_page.card_db_name).to eq(card_db_name)
          expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
          expect(main_page.category).to eq(YugiohX2::Card::Categories::SYNCHRO)
          expect(main_page.card_name).to eq("Stardust Dragon")
          expect(main_page.level).to eq('8')
          expect(main_page.rank).to eq(nil)
          expect(main_page.pendulum_scale).to eq(nil)
          expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::WIND)
          expect(main_page.property).to eq(nil)
          expect(main_page.types).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                  YugiohX2::Card::Categories::SYNCHRO,
                                                  YugiohX2::Card::Categories::EFFECT])
          expect(main_page.attack).to eq('2500')
          expect(main_page.defense).to eq('2000')
          expect(main_page.card_description).to eq(expected_description.strip)
          expect(main_page.serial_number).to eq('44508094')
        end
      end

      context 'Synchro Tuner Monster' do
        let(:card_db_name) { "Formula_Synchron" }
        let(:expected_description) do
          <<EOF
1 Tuner + 1 non-Tuner monster
When this card is Synchro Summoned: You can draw 1 card. Once per Chain, during your opponent's Main Phase, you can: Immediately after this effect resolves, Synchro Summon using this card you control (this is a Quick Effect).
EOF
        end

        it 'should be Synchro Tuner' do
          expect(main_page.card_db_name).to eq(card_db_name)
          expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
          expect(main_page.category).to eq(YugiohX2::Card::Categories::SYNCHRO)
          expect(main_page.card_name).to eq("Formula Synchron")
          expect(main_page.level).to eq('2')
          expect(main_page.rank).to eq(nil)
          expect(main_page.pendulum_scale).to eq(nil)
          expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::LIGHT)
          expect(main_page.property).to eq(nil)
          expect(main_page.types).to match_array([YugiohX2::Monster::Species::MACHINE,
                                                  YugiohX2::Card::Categories::SYNCHRO,
                                                  YugiohX2::Monster::Abilities::TUNER,
                                                  YugiohX2::Card::Categories::EFFECT])
          expect(main_page.attack).to eq('200')
          expect(main_page.defense).to eq('1500')
          expect(main_page.card_description).to eq(expected_description.strip)
          expect(main_page.serial_number).to eq('50091196')
        end
      end

      context 'Xyz Monster' do
        let(:card_db_name) { "Bahamut_Shark" }
        let(:expected_description) do
          <<EOF
2 Level 4 WATER monsters
Once per turn: You can detach 1 Xyz Material from this card; Special Summon 1 Rank 3 or lower WATER Xyz Monster from your Extra Deck. This card cannot attack for the rest of this turn.
EOF
        end

        it 'should be Xyz' do
          expect(main_page.card_db_name).to eq(card_db_name)
          expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
          expect(main_page.category).to eq(YugiohX2::Card::Categories::XYZ)
          expect(main_page.card_name).to eq("Bahamut Shark")
          expect(main_page.level).to eq(nil)
          expect(main_page.rank).to eq('4')
          expect(main_page.pendulum_scale).to eq(nil)
          expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::WATER)
          expect(main_page.property).to eq(nil)
          expect(main_page.types).to match_array([YugiohX2::Monster::Species::SEA_SERPENT,
                                                  YugiohX2::Card::Categories::XYZ,
                                                  YugiohX2::Card::Categories::EFFECT])
          expect(main_page.attack).to eq('2600')
          expect(main_page.defense).to eq('2100')
          expect(main_page.card_description).to eq(expected_description.strip)
          expect(main_page.serial_number).to eq('00440556')
        end
      end

      context 'Pendulum Card' do
        let(:card_db_name) { "Odd-Eyes_Venom_Dragon" }
        let(:expected_description) do
          <<EOF
Pendulum Effect
 Once per turn: You can target 1 Fusion Monster you control; it gains 1000 ATK for each monster your opponent currently controls until the end of this turn (even if this card leaves the field).

 Monster Effect
 1 "Starving Venom" monster + 1 "Odd-Eyes" monsterMust be either Fusion Summoned or Pendulum Summoned, and cannot be Special Summoned by other ways. Once per turn: You can target 1 face-up monster your opponent controls; until the End Phase, this card gains ATK equal to that monster's current ATK, this card's name becomes that monster's original name, and replace this effect with that monster's original effects. If this card in the Monster Zone is destroyed: You can Special Summon 1 card from your Pendulum Zone, and if you do, place this card in your Pendulum Zone.
EOF
        end

        it 'should be Pendulum' do
          expect(main_page.card_db_name).to eq(card_db_name)
          expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
          expect(main_page.category).to eq(YugiohX2::Card::Categories::PENDULUM)
          expect(main_page.card_name).to eq("Odd-Eyes Venom Dragon")
          expect(main_page.level).to eq('10')
          expect(main_page.rank).to eq(nil)
          expect(main_page.pendulum_scale).to eq('1')
          expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
          expect(main_page.property).to eq(nil)
          expect(main_page.types).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                  YugiohX2::Card::Categories::FUSION,
                                                  YugiohX2::Card::Categories::PENDULUM,
                                                  YugiohX2::Card::Categories::EFFECT])
          expect(main_page.attack).to eq('3300')
          expect(main_page.defense).to eq('2500')
          expect(main_page.card_description).to eq(expected_description.strip)
          expect(main_page.serial_number).to eq('45014450')
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

          it 'should be a Normal Spell' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::NON_MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::SPELL)
            expect(main_page.card_name).to eq("Monster Reborn")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(nil)
            expect(main_page.property).to eq(YugiohX2::NonMonster::Properties::NORMAL)
            expect(main_page.types).to match_array([])
            expect(main_page.attack).to eq(nil)
            expect(main_page.defense).to eq(nil)
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('83764718')
          end
        end

        context 'Continuous' do
          let(:card_db_name) { "Burning_Land" }
          let(:expected_description) do
            <<EOF
When this card is activated: If there are any Field Spell Cards on the field, destroy them. During each player's Standby Phase: The turn player takes 500 damage.
EOF
          end

          it 'should be a Continuous Spell' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::NON_MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::SPELL)
            expect(main_page.card_name).to eq("Burning Land")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(nil)
            expect(main_page.property).to eq(YugiohX2::NonMonster::Properties::CONTINUOUS)
            expect(main_page.types).to match_array([])
            expect(main_page.attack).to eq(nil)
            expect(main_page.defense).to eq(nil)
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('24294108')
          end
        end

        context 'Equip' do
          let(:card_db_name) { "Black_Pendant" }
          let(:expected_description) do
            <<EOF
The equipped monster gains 500 ATK. When this card is sent from the field to the Graveyard: Inflict 500 damage to your opponent.
EOF
          end

          it 'should be a Equip Spell' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::NON_MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::SPELL)
            expect(main_page.card_name).to eq("Black Pendant")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(nil)
            expect(main_page.property).to eq(YugiohX2::NonMonster::Properties::EQUIP)
            expect(main_page.types).to match_array([])
            expect(main_page.attack).to eq(nil)
            expect(main_page.defense).to eq(nil)
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('65169794')
          end
        end

        context 'QuickPlay' do
          let(:card_db_name) { "Mystical_Space_Typhoon" }
          let(:expected_description) do
            <<EOF
Target 1 Spell/Trap Card on the field; destroy that target.
EOF
          end

          it 'should be a Quick-Play Spell' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::NON_MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::SPELL)
            expect(main_page.card_name).to eq("Mystical Space Typhoon")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(nil)
            expect(main_page.property).to eq(YugiohX2::NonMonster::Properties::QUICK_PLAY)
            expect(main_page.types).to match_array([])
            expect(main_page.attack).to eq(nil)
            expect(main_page.defense).to eq(nil)
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('05318639')
          end
        end

        context 'Field' do
          let(:card_db_name) { "Mausoleum_of_White" }
          let(:expected_description) do
            <<EOF
During your Main Phase, you can Normal Summon 1 Level 1 LIGHT Tuner monster in addition to your Normal Summon/Set. (You can only gain this effect once per turn.) Once per turn: You can target 1 face-up monster you control; send 1 Normal Monster from your hand or Deck to the Graveyard, and if you do, the targeted monster gains ATK and DEF equal to the Level of the monster sent to the Graveyard x 100, until the end of this turn (even if this card leaves the field). You can banish this card from your Graveyard; add 1 "Burst Stream of Destruction" from your Deck to your hand.
EOF
          end

          it 'should be a Field Spell' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::NON_MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::SPELL)
            expect(main_page.card_name).to eq("Mausoleum of White")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(nil)
            expect(main_page.property).to eq(YugiohX2::NonMonster::Properties::FIELD)
            expect(main_page.types).to match_array([])
            expect(main_page.attack).to eq(nil)
            expect(main_page.defense).to eq(nil)
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('24382602')
          end
        end

        context 'Ritual' do
          let(:card_db_name) { "Black_Luster_Ritual" }
          let(:expected_description) do
            <<EOF
This card is used to Ritual Summon "Black Luster Soldier". You must also Tribute monsters from your hand or field whose total Levels equal 8 or more.
EOF
          end

          it 'should be a Ritual Spell' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::NON_MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::SPELL)
            expect(main_page.card_name).to eq("Black Luster Ritual")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(nil)
            expect(main_page.property).to eq(YugiohX2::NonMonster::Properties::RITUAL)
            expect(main_page.types).to match_array([])
            expect(main_page.attack).to eq(nil)
            expect(main_page.defense).to eq(nil)
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('55761792')
          end
        end
      end

      context 'Trap Card' do
        context "Normal" do
          let(:card_db_name) { "Trap_Hole" }
          let(:expected_description) do
            <<EOF
When your opponent Normal or Flip Summons 1 monster with 1000 or more ATK: Target that monster; destroy that target.
EOF
          end

          it 'should be Trap' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::NON_MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::TRAP)
            expect(main_page.card_name).to eq("Trap Hole")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(nil)
            expect(main_page.property).to eq(YugiohX2::NonMonster::Properties::NORMAL)
            expect(main_page.types).to match_array([])
            expect(main_page.attack).to eq(nil)
            expect(main_page.defense).to eq(nil)
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('04206964')
          end
        end

        context "Continuous" do
          let(:card_db_name) { "Call_of_the_Haunted" }
          let(:expected_description) do
            <<EOF
Activate this card by targeting 1 monster in your Graveyard; Special Summon that target in Attack Position. When this card leaves the field, destroy that target. When that target is destroyed, destroy this card.
EOF
          end

          it 'should be a Continuous Trap' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::NON_MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::TRAP)
            expect(main_page.card_name).to eq("Call of the Haunted")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(nil)
            expect(main_page.property).to eq(YugiohX2::NonMonster::Properties::CONTINUOUS)
            expect(main_page.types).to match_array([])
            expect(main_page.attack).to eq(nil)
            expect(main_page.defense).to eq(nil)
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('97077563')
          end
        end

        context "Counter" do
          let(:card_db_name) { "Solemn_Judgment" }
          let(:expected_description) do
            <<EOF
When a monster would be Summoned, OR a Spell/Trap Card is activated: Pay half your Life Points; negate the Summon or activation, and if you do, destroy that card.
EOF
          end

          it 'should be Counter Trap' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::NON_MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::TRAP)
            expect(main_page.card_name).to eq("Solemn Judgment")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(nil)
            expect(main_page.property).to eq(YugiohX2::NonMonster::Properties::COUNTER)
            expect(main_page.types).to match_array([])
            expect(main_page.attack).to eq(nil)
            expect(main_page.defense).to eq(nil)
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('41420027')
          end
        end
      end
    end
  end
end

