ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.data_sources.include?('users')
    create_table :users do |table|
      table.column :username, :string
      table.column :encrypted_password, :binary
      table.column :dp, :integer, default: 0

      table.index :username, unique: true
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('sessions')
    create_table :sessions do |table|
      table.column :user_id, :integer
      table.column :uuid, :string
      table.column :remote_ip, :string
      table.column :expires_at, :datetime

      table.index :user_id, unique: true
      table.index :uuid, unique: true
    end
  end

  unless ActiveRecord::Base.connection.data_sources.include?('user_cards')
    create_table :user_cards do |table|
      table.column :user_id, :integer
      table.column :card_id, :integer
      table.column :count, :integer, default: 1

      table.index [:user_id, :card_id], unique: true
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

  YugiohX2Lib::Utils.create_view :monsters, <<EOF
CREATE VIEW monsters AS
SELECT c.id as card_id,
       c.db_name as db_name,
       c.name as name,
       c.category as category,
       c.level as level,
       c.rank as rank,
       c.pendulum_scale as pendulum_scale,
       c.card_attribute as card_attribute,
       c.attack as attack,
       c.defense as defense,
       c.serial_number as serial_number,
       c.description as description
FROM cards c
WHERE c.card_type = 'Monster'
EOF

  YugiohX2Lib::Utils.create_view :non_monsters, <<EOF
CREATE VIEW non_monsters AS
SELECT c.id as card_id,
       c.db_name as db_name,
       c.name as name,
       c.category as category,
       c.property as property,
       c.serial_number as serial_number,
       c.description as description
FROM cards c
WHERE c.card_type = 'NonMonster'
EOF
end
