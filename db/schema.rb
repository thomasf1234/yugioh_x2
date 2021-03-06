require 'yaml'

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.data_sources.include?('users')
    create_table :users do |table|
      table.column :username, :string
      table.column :encrypted_password, :binary
      table.column :admin, :boolean, default: false
      table.column :dp, :integer, default: 0

      table.index :username, unique: true
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('user_cards')
    create_table :user_cards do |table|
      table.column :user_id, :integer
      table.column :card_id, :integer
      table.column :artwork_id, :integer
      table.column :count, :integer, default: 1

      table.index [:user_id, :card_id], unique: true
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('user_decks')
    create_table :user_decks do |table|
      table.column :user_id, :integer
      table.column :main_card_ids, :text, default: [].to_yaml
      table.column :side_card_ids, :text, default: [].to_yaml
      table.column :extra_card_ids, :text, default: [].to_yaml

      table.index :user_id
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('cards')
    create_table :cards do |table|
      table.column :db_name, :string
      table.column :card_type, :string
      table.column :category, :string
      table.column :name, :string
      table.column :level, :integer
      table.column :rank, :integer
      table.column :pendulum_scale, :integer
      table.column :card_attribute, :string
      table.column :property, :string
      table.column :attack, :string
      table.column :defense, :string
      table.column :serial_number, :string
      table.column :description, :string

      table.index :serial_number
      table.index :db_name, unique: true
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('unusable_cards')
    create_table :unusable_cards do |table|
      table.column :db_name, :string
      table.column :reason, :string

      table.index :db_name, unique: true
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('monster_types')
    create_table :monster_types do |table|
      table.column :name, :string
      table.column :card_id, :integer
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('artworks')
    create_table :artworks do |table|
      table.column :source_url, :string
      table.column :image_path, :string
      table.column :card_id, :integer
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('booster_packs')
    create_table :booster_packs do |table|
      table.column :db_name, :string
      table.column :name, :string
      table.column :image_path, :string
      table.column :cost, :integer

      table.index :db_name, unique: true
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('booster_pack_cards')
    create_table :booster_pack_cards do |table|
      table.column :booster_pack_id, :integer
      table.column :card_id, :integer
      table.column :rarity, :string
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('forbidden_limited_lists')
    create_table :forbidden_limited_lists do |table|
      table.column :effective_from, :date

      table.index :effective_from, unique: true
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('forbidden_limited_list_cards')
    create_table :forbidden_limited_list_cards do |table|
      table.column :forbidden_limited_list_id, :integer
      table.column :card_id, :integer
      table.column :limited_status, :string

      table.index [:forbidden_limited_list_id, :card_id], unique: true, name: 'unique_index_fll_id_card_id'
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('duels')
    create_table :duels do |table|
      table.column :user_a_id, :integer
      table.column :user_b_id, :integer
      table.column :state, :string, default: 'pending'
      table.column :result, :string
    end
  end

#   YugiohX2Lib::Utils.create_view :monsters, <<EOF
# CREATE VIEW IF NOT EXISTS monsters AS
# SELECT c.id as card_id,
#        c.db_name as db_name,
#        c.name as name,
#        c.category as category,
#        c.level as level,
#        c.rank as rank,
#        c.pendulum_scale as pendulum_scale,
#        c.card_attribute as card_attribute,
#        c.attack as attack,
#        c.defense as defense,
#        c.serial_number as serial_number,
#        c.description as description
# FROM cards c
# WHERE c.card_type = 'Monster'
# EOF

#   YugiohX2Lib::Utils.create_view :non_monsters, <<EOF
# CREATE VIEW IF NOT EXISTS non_monsters AS
# SELECT c.id as card_id,
#        c.db_name as db_name,
#        c.name as name,
#        c.category as category,
#        c.property as property,
#        c.serial_number as serial_number,
#        c.description as description
# FROM cards c
# WHERE c.card_type = 'NonMonster'
# EOF
end
