FactoryGirl.define do
  factory :xyz_card, class: YugiohX2::Card do
    db_name 'Bahamut_Shark'
    card_type 'Monster'
    category 'Xyz'
    name 'Bahamut Shark'
    level nil
    rank 4
    pendulum_scale nil
    card_attribute 'WATER'
    property nil
    attack '2600'
    defense '2100'
    serial_number '00440556'
    description "2 Level 4 WATER monsters
Once per turn: You can detach 1 Xyz Material from this card; Special Summon 1 Rank 3 or lower WATER Xyz Monster from your Extra Deck. This card cannot attack for the rest of this turn."
  end

  factory :normal_card, class: YugiohX2::Card do
    db_name 'Dark_Magician'
    card_type 'Monster'
    category 'Normal'
    name 'Dark Magician'
    level 7
    rank nil
    pendulum_scale nil
    card_attribute 'DARK'
    property nil
    attack '2500'
    defense '2100'
    serial_number '46986414'
    description "The ultimate wizard in terms of attack and defense."
  end

  factory :fusion_card, class: YugiohX2::Card do
    db_name 'Five-Headed_Dragon'
    card_type 'Monster'
    category 'Fusion'
    name 'Five-Headed Dragon'
    level 12
    rank nil
    pendulum_scale nil
    card_attribute 'DARK'
    property nil
    attack '5000'
    defense '5000'
    serial_number '99267150'
    description "5 Dragon-Type monsters
Must be Fusion Summoned, and cannot be Special Summoned by other ways. Cannot be destroyed by battle with a DARK, EARTH, WATER, FIRE, or WIND monster."
  end

  factory :ritual_card, class: YugiohX2::Card do
    db_name 'Magician_of_Black_Chaos'
    card_type 'Monster'
    category 'Ritual'
    name 'Magician of Black Chaos'
    level 8
    rank nil
    pendulum_scale nil
    card_attribute 'DARK'
    property nil
    attack '2800'
    defense '2600'
    serial_number '30208479'
    description "You can Ritual Summon this card with \"Black Magic Ritual\"."
  end

  factory :spell_card, class: YugiohX2::Card do
    db_name 'Monster_Reborn'
    card_type 'NonMonster'
    category 'Spell'
    name 'Monster Reborn'
    level nil
    rank nil
    pendulum_scale nil
    card_attribute nil
    property 'Normal'
    attack nil
    defense nil
    serial_number '83764718'
    description "Target 1 monster in either player's Graveyard; Special Summon it."
  end

  factory :pendulum_card, class: YugiohX2::Card do
    db_name 'Odd-Eyes_Raging_Dragon'
    card_type 'Monster'
    category 'Pendulum'
    name 'Odd-Eyes Raging Dragon'
    level nil
    rank 7
    pendulum_scale 1
    card_attribute 'DARK'
    property nil
    attack '3000'
    defense '2500'
    serial_number '86238081'
    description "Pendulum Effect
 Once per turn, if you have no cards in your other Pendulum Zone: You can place 1 Pendulum Monster from your Deck in your Pendulum Zone.

 Monster Effect
 2 Level 7 Dragon-Type monstersIf you can Pendulum Summon Level 7, you can Pendulum Summon this face-up card in your Extra Deck. If this card in the Monster Zone is destroyed: You can place it in your Pendulum Zone. If this card is Xyz Summoned using an Xyz Monster as Material, it gains these effects.● It can make a second attack during each Battle Phase.● Once per turn: You can detach 1 Xyz Material from it; destroy as many cards your opponent controls as possible, and if you do, this card gains 200 ATK for each, until the end of this turn."
  end

  factory :trap_card, class: YugiohX2::Card do
    db_name 'Solemn_Judgment'
    card_type 'NonMonster'
    category 'Trap'
    name 'Solemn Judgment'
    level nil
    rank nil
    pendulum_scale nil
    card_attribute nil
    property 'Counter'
    attack nil
    defense nil
    serial_number '41420027'
    description "When a monster would be Summoned, OR a Spell/Trap Card is activated: Pay half your Life Points; negate the Summon or activation, and if you do, destroy that card."
  end

  factory :synchro_card, class: YugiohX2::Card do
    db_name 'Stardust_Dragon'
    card_type 'Monster'
    category 'Synchro'
    name 'Stardust Dragon'
    level 8
    rank nil
    pendulum_scale nil
    card_attribute 'WIND'
    property nil
    attack '2500'
    defense '2000'
    serial_number '44508094'
    description "1 Tuner + 1 or more non-Tuner monsters
During either player's turn, when a card or effect is activated that would destroy a card(s) on the field: You can Tribute this card; negate the activation, and if you do, destroy it. During the End Phase, if this effect was activated this turn (and was not negated): You can Special Summon this card from your Graveyard."
  end
end


# cards.each do |card|
#   puts <<EOF
#   factory :#{card.category.downcase.underscore}_card, class: YugiohX2::Card do
#     db_name '#{card.db_name}'
#     card_type '#{card.card_type}'
#     category '#{card.category}'
#     name '#{card.name}'
#     level #{card.level}
#     rank #{card.rank}
#     pendulum_scale #{card.pendulum_scale}
#     card_attribute '#{card.card_attribute}'
#     property '#{card.property}'
#     attack '#{card.attack}'
#     defense '#{card.defense}'
#     serial_number '#{card.serial_number}'
#     description "#{card.description}"
#   end
#
# EOF
# end
