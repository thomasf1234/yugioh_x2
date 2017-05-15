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
        let(:card_db_name) { "Monster_Reborn" }
        let(:expected_description) do
          <<EOF
Target 1 monster in either player's Graveyard; Special Summon it.
EOF
        end

        it 'should be Spell' do
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

      context 'Trap Card' do
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
    end
  end
end

