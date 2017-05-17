require 'spec_helper'

module YugiohX2Spec
  RSpec.describe YugiohX2Lib::ExternalPages::MainPage do
    describe 'main_page' do
      let(:main_page) { YugiohX2Lib::ExternalPages::MainPage.new(card_db_name) }

      context 'Normal Monster' do
        context "Normal" do
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
            expect(main_page.level).to eq(7)
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

        context 'Tuner Monster' do
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
            expect(main_page.level).to eq(5)
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

          it 'should be Effect' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(main_page.card_name).to eq("Van'Dalgyon the Dark Dragon Lord")
            expect(main_page.level).to eq(8)
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

        context 'Flip' do
          let(:card_db_name) { "Penguin_Soldier" }
          let(:expected_description) do
            <<EOF
FLIP: You can target up to 2 monsters on the field; return those targets to the hand.
EOF
          end

          it 'should be Effect Flip' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(main_page.card_name).to eq("Penguin Soldier")
            expect(main_page.level).to eq(2)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::WATER)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::AQUA,
                                                    YugiohX2::Card::Categories::EFFECT])
            expect(main_page.attack).to eq('750')
            expect(main_page.defense).to eq('500')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('93920745')
          end
        end

        context 'Toon' do
          let(:card_db_name) { "Toon_Summoned_Skull" }
          let(:expected_description) do
            <<EOF
(This card is always treated as an "Archfiend" card.)
Cannot be Normal Summoned/Set. Cannot be Special Summoned unless you control "Toon World". Must first be Special Summoned (from your hand) by Tributing the same number of monsters needed for a Tribute Summon (normally 1). This card cannot attack the turn it is Special Summoned. You must pay 500 Life Points to declare an attack with this monster. If "Toon World" on the field is destroyed, destroy this card. This card can attack your opponent directly, unless they control a Toon Monster. If they do control one, this card must target a Toon Monster for its attacks.
EOF
          end

          it 'should be Effect Toon' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(main_page.card_name).to eq("Toon Summoned Skull")
            expect(main_page.level).to eq(6)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::FIEND,
                                                    YugiohX2::Monster::Abilities::TOON])
            expect(main_page.attack).to eq('2500')
            expect(main_page.defense).to eq('1200')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('91842653')
          end
        end

        context 'Spirit' do
          let(:card_db_name) { "Yamata_Dragon" }
          let(:expected_description) do
            <<EOF
This card cannot be Special Summoned. This card returns to its owner's hand during the End Phase of the turn it is Normal Summoned or flipped face-up. When this card inflicts Battle Damage to your opponent, draw cards until you have 5 cards in your hand.
EOF
          end

          it 'should be Effect Spirit' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(main_page.card_name).to eq("Yamata Dragon")
            expect(main_page.level).to eq(7)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::FIRE)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                    YugiohX2::Monster::Abilities::SPIRIT])
            expect(main_page.attack).to eq('2600')
            expect(main_page.defense).to eq('3100')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('76862289')
          end
        end

        context 'Union' do
          let(:card_db_name) { "Y-Dragon_Head" }
          let(:expected_description) do
            <<EOF
Once per turn, you can either: Target 1 "X-Head Cannon" you control; equip this card to that target, OR: Unequip this card and Special Summon it. A monster equipped with this card gains 400 ATK and DEF, also if the equipped monster would be destroyed by battle or card effect, destroy this card instead.
EOF
          end

          it 'should be Effect Union' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(main_page.card_name).to eq("Y-Dragon Head")
            expect(main_page.level).to eq(4)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::LIGHT)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::MACHINE,
                                                    YugiohX2::Card::Categories::EFFECT,
                                                    YugiohX2::Monster::Abilities::UNION])
            expect(main_page.attack).to eq('1500')
            expect(main_page.defense).to eq('1600')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('65622692')
          end
        end

        context 'Gemini' do
          let(:card_db_name) { "Il_Blud" }
          let(:expected_description) do
            <<EOF
This card is treated as a Normal Monster while face-up on the field or in the Graveyard. While this card is face-up on the field, you can Normal Summon it to have it become an Effect Monster with this effect.
● Once per turn: You can Special Summon 1 Zombie-Type monster from your hand or from either player's Graveyard. When this card leaves the field, destroy all Zombie-Type monsters Special Summoned by this card's effect.
EOF
          end

          it 'should be Effect Gemini' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(main_page.card_name).to eq("Il Blud")
            expect(main_page.level).to eq(6)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::ZOMBIE,
                                                    YugiohX2::Monster::Abilities::GEMINI])
            expect(main_page.attack).to eq('2100')
            expect(main_page.defense).to eq('800')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('70595331')
          end
        end

        context 'Tuner' do
          let(:card_db_name) { "Arcane_Apprentice" }
          let(:expected_description) do
            <<EOF
If this card is sent to the Graveyard for a Synchro Summon, you can add 1 "Assault Mode Activate" from your Deck to your hand.
EOF
          end

          it 'should be Effect Tuner' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::EFFECT)
            expect(main_page.card_name).to eq("Arcane Apprentice")
            expect(main_page.level).to eq(2)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::FIRE)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::SPELLCASTER,
                                                    YugiohX2::Monster::Abilities::TUNER])
            expect(main_page.attack).to eq('1000')
            expect(main_page.defense).to eq('400')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('40048324')
          end
        end
      end

      context 'Fusion Monster' do
        context 'Normal' do
          let(:card_db_name) { "Black_Skull_Dragon" }
          let(:expected_description) do
            <<EOF
"Summoned Skull" + "Red-Eyes B. Dragon"



(This card is always treated as an "Archfiend" card.)
EOF
          end

          it 'should be Fusion Normal' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::FUSION)
            expect(main_page.card_name).to eq("B. Skull Dragon")
            expect(main_page.level).to eq(9)
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

        context 'Effect' do
          let(:card_db_name) { "Five-Headed_Dragon" }
          let(:expected_description) do
            <<EOF
5 Dragon-Type monsters
Must be Fusion Summoned, and cannot be Special Summoned by other ways. Cannot be destroyed by battle with a DARK, EARTH, WATER, FIRE, or WIND monster.
EOF
          end

          it 'should be Fusion Effect' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::FUSION)
            expect(main_page.card_name).to eq("Five-Headed Dragon")
            expect(main_page.level).to eq(12)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                    YugiohX2::Card::Categories::EFFECT,
                                                    YugiohX2::Card::Categories::FUSION])
            expect(main_page.attack).to eq('5000')
            expect(main_page.defense).to eq('5000')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('99267150')
          end
        end

        context 'Tuner' do
          let(:card_db_name) { "Sea_Monster_of_Theseus" }
          let(:expected_description) do
            <<EOF
2 Tuners
EOF
          end

          it 'should be Fusion Tuner' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::FUSION)
            expect(main_page.card_name).to eq("Sea Monster of Theseus")
            expect(main_page.level).to eq(5)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::WATER)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::ZOMBIE,
                                                    YugiohX2::Monster::Abilities::TUNER,
                                                    YugiohX2::Card::Categories::FUSION])
            expect(main_page.attack).to eq('2200')
            expect(main_page.defense).to eq('1800')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('96334243')
          end
        end
      end

      context 'Ritual Monster' do
        context "Normal" do
          let(:card_db_name) { "Magician_of_Black_Chaos" }
          let(:expected_description) do
            <<EOF
You can Ritual Summon this card with "Black Magic Ritual".
EOF
          end

          it 'should be Ritual Normal' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::RITUAL)
            expect(main_page.card_name).to eq("Magician of Black Chaos")
            expect(main_page.level).to eq(8)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::SPELLCASTER,
                                                    YugiohX2::Card::Categories::RITUAL])
            expect(main_page.attack).to eq('2800')
            expect(main_page.defense).to eq('2600')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('30208479')
          end
        end

        context "Effect" do
          let(:card_db_name) { "Relinquished" }
          let(:expected_description) do
            <<EOF
You can Ritual Summon this card with "Black Illusion Ritual". Once per turn: You can target 1 monster your opponent controls; equip that target to this card. (You can only equip 1 monster at a time to this card with this effect.) This card's ATK and DEF become equal to that equipped monster's. If this card would be destroyed by battle, destroy that equipped monster instead. While equipped with that monster, any battle damage you take from battles involving this card inflicts equal effect damage to your opponent.
EOF
          end

          it 'should be Ritual Effect' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::RITUAL)
            expect(main_page.card_name).to eq("Relinquished")
            expect(main_page.level).to eq(1)
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

        context "Spirit" do
          let(:card_db_name) { "Shinobaron_Peacock" }
          let(:expected_description) do
            <<EOF
You can Ritual Summon this card with "Shinobird's Calling". Must be Ritual Summoned, and cannot be Special Summoned by other ways. If this card is Ritual Summoned: You can return up to 3 monsters your opponent controls to the hand, then you can Special Summon 1 Level 4 or lower Spirit monster from your hand, ignoring its Summoning conditions. Once per turn, during the End Phase, if this card was Special Summoned this turn: Return it to the hand, and if you do, Special Summon 2 "Shinobird Tokens" (Winged Beast-Type/WIND/Level 4/ATK 1500/DEF 1500).
EOF
          end

          it 'should be Ritual Spirit' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::RITUAL)
            expect(main_page.card_name).to eq("Shinobaron Peacock")
            expect(main_page.level).to eq(8)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::WIND)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::WINGED_BEAST,
                                                    YugiohX2::Monster::Abilities::SPIRIT,
                                                    YugiohX2::Card::Categories::RITUAL,
                                                    YugiohX2::Card::Categories::EFFECT])
            expect(main_page.attack).to eq('3000')
            expect(main_page.defense).to eq('2500')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('52900000')
          end
        end
      end

      context 'Synchro Monster' do
        context "Normal" do
          let(:card_db_name) { "Gaia_Knight,_the_Force_of_Earth" }
          let(:expected_description) do
            <<EOF
1 Tuner + 1 or more non-Tuner monsters
EOF
          end

          it 'should be Synchro Normal' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::SYNCHRO)
            expect(main_page.card_name).to eq("Gaia Knight, the Force of Earth")
            expect(main_page.level).to eq(6)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::EARTH)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::WARRIOR,
                                                    YugiohX2::Card::Categories::SYNCHRO])
            expect(main_page.attack).to eq('2600')
            expect(main_page.defense).to eq('800')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('97204936')
          end
        end

        context "Effect" do
          let(:card_db_name) { "Stardust_Dragon" }
          let(:expected_description) do
            <<EOF
1 Tuner + 1 or more non-Tuner monsters
During either player's turn, when a card or effect is activated that would destroy a card(s) on the field: You can Tribute this card; negate the activation, and if you do, destroy it. During the End Phase, if this effect was activated this turn (and was not negated): You can Special Summon this card from your Graveyard.
EOF
          end

          it 'should be Synchro Effect' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::SYNCHRO)
            expect(main_page.card_name).to eq("Stardust Dragon")
            expect(main_page.level).to eq(8)
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

        context 'Tuner' do
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
            expect(main_page.level).to eq(2)
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
      end

      context 'Xyz Monster' do
        context 'Normal' do
          let(:card_db_name) { "Gem-Knight_Pearl" }
          let(:expected_description) do
            <<EOF
2 Level 4 monsters
EOF
          end

          it 'should be Xyz Normal' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::XYZ)
            expect(main_page.card_name).to eq("Gem-Knight Pearl")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(4)
            expect(main_page.pendulum_scale).to eq(nil)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::EARTH)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::ROCK,
                                                    YugiohX2::Card::Categories::XYZ])
            expect(main_page.attack).to eq('2600')
            expect(main_page.defense).to eq('1900')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('71594310')
          end
        end

        context 'Effect' do
          let(:card_db_name) { "Bahamut_Shark" }
          let(:expected_description) do
            <<EOF
2 Level 4 WATER monsters
Once per turn: You can detach 1 Xyz Material from this card; Special Summon 1 Rank 3 or lower WATER Xyz Monster from your Extra Deck. This card cannot attack for the rest of this turn.
EOF
          end

          it 'should be Xyz Effect' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::XYZ)
            expect(main_page.card_name).to eq("Bahamut Shark")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(4)
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
      end

      context 'Pendulum Card' do
        context "Effect" do
          let(:card_db_name) { "Odd-Eyes_Venom_Dragon" }
          let(:expected_description) do
            <<EOF
Pendulum Effect
 Once per turn: You can target 1 Fusion Monster you control; it gains 1000 ATK for each monster your opponent currently controls until the end of this turn (even if this card leaves the field).

 Monster Effect
 1 "Starving Venom" monster + 1 "Odd-Eyes" monsterMust be either Fusion Summoned or Pendulum Summoned, and cannot be Special Summoned by other ways. Once per turn: You can target 1 face-up monster your opponent controls; until the End Phase, this card gains ATK equal to that monster's current ATK, this card's name becomes that monster's original name, and replace this effect with that monster's original effects. If this card in the Monster Zone is destroyed: You can Special Summon 1 card from your Pendulum Zone, and if you do, place this card in your Pendulum Zone.
EOF
          end

          it 'should be Pendulum Effect' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::PENDULUM)
            expect(main_page.card_name).to eq("Odd-Eyes Venom Dragon")
            expect(main_page.level).to eq(10)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(1)
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

        context 'Fusion' do
          let(:card_db_name) { "Supreme_King_Z-ARC" }
          let(:expected_description) do
            <<EOF
Pendulum Effect
 Fusion, Synchro, and Xyz Monsters your opponent controls cannot activate their effects. Once per turn, when your opponent adds a card(s) from their Deck to their hand (except during the Draw Phase or the Damage Step): You can destroy that card(s).

 Monster Effect
 4 Dragon-Type monsters (1 Fusion, 1 Synchro, 1 Xyz, and 1 Pendulum)Must be Fusion Summoned and cannot be Special Summoned by other ways. If this card is Special Summoned: Destroy all cards your opponent controls. Cannot be destroyed by your opponent's card effects. Your opponent cannot target this card with card effects. When this card destroys an opponent's monster by battle: You can Special Summon 1 "Supreme King Dragon" monster from your Deck or Extra Deck. If this card in the Monster Zone is destroyed by battle or card effect: You can place this card in your Pendulum Zone.
EOF
          end

          it 'should be Pendulum Fusion' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::PENDULUM)
            expect(main_page.card_name).to eq("Supreme King Z-ARC")
            expect(main_page.level).to eq(12)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(1)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                    YugiohX2::Card::Categories::EFFECT,
                                                    YugiohX2::Card::Categories::PENDULUM,
                                                    YugiohX2::Card::Categories::FUSION])
            expect(main_page.attack).to eq('4000')
            expect(main_page.defense).to eq('4000')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('13331639')
          end
        end

        context 'Synchro' do
          let(:card_db_name) { "Nirvana_High_Paladin" }
          let(:expected_description) do
            <<EOF
Pendulum Effect
 If a Pendulum Monster you control attacks, for that battle, it cannot be destroyed by battle, also you take no battle damage. At the end of the Damage Step, if a Pendulum Monster you control attacked: All monsters your opponent currently controls lose ATK equal to that attacking monster's ATK, until the end of this turn.

 Monster Effect
 1 Tuner + 1 or more non-Tuner Synchro MonstersFor this card's Synchro Summon, you can treat 1 Pendulum Summoned Pendulum Monster you control as a Tuner. If this card is Synchro Summoned using a Pendulum Summoned Pendulum Monster Tuner: You can target 1 card in your Graveyard; add it to your hand. When this card destroys an opponent's monster by battle: You can halve your opponent's LP. If this card in the Monster Zone is destroyed by battle or card effect: You can place this card in your Pendulum Zone.
EOF
          end

          it 'should be Pendulum Synchro' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::PENDULUM)
            expect(main_page.card_name).to eq("Nirvana High Paladin")
            expect(main_page.level).to eq(10)
            expect(main_page.rank).to eq(nil)
            expect(main_page.pendulum_scale).to eq(8)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::SPELLCASTER,
                                                    YugiohX2::Card::Categories::EFFECT,
                                                    YugiohX2::Card::Categories::PENDULUM,
                                                    YugiohX2::Card::Categories::SYNCHRO])
            expect(main_page.attack).to eq('3300')
            expect(main_page.defense).to eq('2500')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('80896940')
          end
        end

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

          it 'should be Pendulum Xyz' do
            expect(main_page.card_db_name).to eq(card_db_name)
            expect(main_page.card_type).to eq(YugiohX2::Card::Types::MONSTER)
            expect(main_page.category).to eq(YugiohX2::Card::Categories::PENDULUM)
            expect(main_page.card_name).to eq("Odd-Eyes Raging Dragon")
            expect(main_page.level).to eq(nil)
            expect(main_page.rank).to eq(7)
            expect(main_page.pendulum_scale).to eq(1)
            expect(main_page.attribute).to eq(YugiohX2::Monster::Elements::DARK)
            expect(main_page.property).to eq(nil)
            expect(main_page.types).to match_array([YugiohX2::Monster::Species::DRAGON,
                                                    YugiohX2::Card::Categories::EFFECT,
                                                    YugiohX2::Card::Categories::PENDULUM,
                                                    YugiohX2::Card::Categories::XYZ])
            expect(main_page.attack).to eq('3000')
            expect(main_page.defense).to eq('2500')
            expect(main_page.card_description).to eq(expected_description.strip)
            expect(main_page.serial_number).to eq('86238081')
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

          it 'should be a Normal Trap' do
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

          it 'should be a Counter Trap' do
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

