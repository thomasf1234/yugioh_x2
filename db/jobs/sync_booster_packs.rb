require 'nokogiri'
require 'fileutils'

#TODO : card validations on properties, types, category inclusion and testing

module YugiohX2Lib
  module Jobs
    class SyncBoosterPacks
      def perform
        bp_db_names = fetch_bp_db_names
        bp_db_names.each do |bp_db_name|
          sync(bp_db_name)
        end
      end

      def sync(bp_db_name)
        YugiohX2::SLogger.instance.debug("***************Starting sync for #{bp_db_name}")

        if YugiohX2::BoosterPack.exists?(db_name: bp_db_name)
          YugiohX2::SLogger.instance.debug("Skipping #{bp_db_name}: Already exists", :yellow)
        else
          artwork_dir = File.join(DATA_DIRECTORY, 'artworks', bp_db_name)
          FileUtils.mkdir_p(artwork_dir)

          begin
            bp_data = fetch_bp_data(bp_db_name)

            ActiveRecord::Base.transaction do
              bp_create_params = {
                  db_name: bp_db_name,
                  name:  bp_data[:name],
                  cost: 300,
                  image_path: File.join(artwork_dir, bp_db_name, '.png')
              }
              bp = YugiohX2::BoosterPack.create!(bp_create_params)

              bp_data[:cards].each do |bpi_data|
                card = YugiohX2::Card.find_by_db_name(bpi_data[:card_db_name])

                if card.nil?
                  raise "Card not found! db_name: #{bpi_data[:card_db_name]}"
                else
                  bpi_create_params = {
                      card_id: YugiohX2::Card.find_by_db_name(bpi_data[:card_db_name]).id,
                      rarity: bpi_data[:rarity],
                      booster_pack_id: bp.id
                  }

                  YugiohX2::BoosterPackCard.create!(bpi_create_params)
                end
              end
            end

            if YugiohX2::BoosterPack.exists?(db_name: bp_db_name)
              YugiohX2::SLogger.instance.debug("Successfully synced #{bp_db_name}", :green)
            else
              YugiohX2::SLogger.instance.debug("Rollback for #{bp_db_name}", :yellow)
            end
          rescue Exception => e
            YugiohX2::SLogger.instance.debug("Failed to sync #{bp_db_name}", :red)
            YugiohX2::SLogger.instance.debug("#{e.class.name} : #{e.message}", :red)
            YugiohX2::SLogger.instance.debug(e.backtrace.join("\n"), :red)
          end
        end

        YugiohX2::SLogger.instance.debug("***************Finished sync for #{bp_db_name}")
      end

      private
      def fetch_bp_data(bp_db_name)
        page = Nokogiri::HTML(Utils.retry_open("#{ExternalPages::YUGIOH_WIKIA_URL}/wiki/#{bp_db_name}"))
        name = page.xpath("//div[@class='header-column header-title']//i").text.strip
        data = {
            name: name,
            cards: []
        }

        rows = page.xpath("//div[@title='English']/table/tr")

        if rows.nil? || rows.empty?
          rows = page.xpath("//div[@title='North American']/table/tr")
        end

        if rows.nil? || rows.empty?
          rows = page.xpath("//table[@class='wikitable sortable card-list']/tr")
        end

        if rows.nil? || rows.empty?
          rows = page.xpath("//table[@class='wikitable sortable']/tr")
        end

        #get row header
        row_header_index = nil
        2.times do |i|
          if rows[i].text.include?('Rarity')
            row_header_index = i
          end
        end
        raise "Row Header not found" if row_header_index == nil
        main_rows = rows[(row_header_index+1)..-1]

        name_col = nil
        rarity_col = nil
        rows[row_header_index].xpath('.//th').each_with_index do |col, index|
          if col.text.strip.downcase.include?("english")
            name_col = index
          end

          if col.text.strip.downcase.include?("rarity")
            rarity_col = index
          end
        end

        if name_col.nil? || rarity_col.nil?
          raise "Could not find name_col or rarity_col"
        end

        main_rows.map do |row|
          columns = row.xpath('./td')

          raw_card_db_name = columns[name_col].xpath('./a').attribute('href').value.split('/wiki/').last
          card_db_name = card_db_name_redirect(raw_card_db_name)
          rarity = columns[rarity_col].xpath('./a').children.first.text.strip.gsub(' ', '')

          data[:cards] << { card_db_name: card_db_name, rarity: rarity }
        end

        data
      end

      def fetch_bp_db_names
        [
            "http://yugioh.wikia.com/wiki/Vol.1",
            "http://yugioh.wikia.com/wiki/Vol.2",
            "http://yugioh.wikia.com/wiki/Vol.3",
            "http://yugioh.wikia.com/wiki/Vol.4",
            "http://yugioh.wikia.com/wiki/Vol.5",
            "http://yugioh.wikia.com/wiki/Vol.6",
            "http://yugioh.wikia.com/wiki/Vol.7",
            "http://yugioh.wikia.com/wiki/Booster_1",
            "http://yugioh.wikia.com/wiki/Booster_2",
            "http://yugioh.wikia.com/wiki/Booster_3",
            "http://yugioh.wikia.com/wiki/Booster_4",
            "http://yugioh.wikia.com/wiki/Booster_5",
            "http://yugioh.wikia.com/wiki/Booster_6",
            "http://yugioh.wikia.com/wiki/Booster_7",

            "http://yugioh.wikia.com/wiki/Magic_Ruler_(Japanese)",
            "http://yugioh.wikia.com/wiki/Pharaoh%27s_Servant_(Japanese)",
            "http://yugioh.wikia.com/wiki/Curse_of_Anubis_(set)",
            "http://yugioh.wikia.com/wiki/Thousand_Eyes_Bible",
            "http://yugioh.wikia.com/wiki/Spell_of_Mask",
            "http://yugioh.wikia.com/wiki/Labyrinth_of_Nightmare_(Japanese)",
            "http://yugioh.wikia.com/wiki/Struggle_of_Chaos",
            "http://yugioh.wikia.com/wiki/Mythological_Age",
            "http://yugioh.wikia.com/wiki/Pharaonic_Guardian_(Japanese)",

            "http://yugioh.wikia.com/wiki/The_New_Ruler",
            "http://yugioh.wikia.com/wiki/Advent_of_Union",
            "http://yugioh.wikia.com/wiki/Champion_of_Black_Magic",
            "http://yugioh.wikia.com/wiki/Power_of_the_Guardian",
            "http://yugioh.wikia.com/wiki/Threat_of_the_Dark_Demon_World",
            "http://yugioh.wikia.com/wiki/Controller_of_Chaos",
            "http://yugioh.wikia.com/wiki/Invader_of_Darkness_(set)",
            "http://yugioh.wikia.com/wiki/The_Sanctuary_in_the_Sky_(set)",
            "http://yugioh.wikia.com/wiki/Pharaoh%27s_Inheritance",


            "http://yugioh.wikia.com/wiki/Legend_of_Blue_Eyes_White_Dragon",
            "http://yugioh.wikia.com/wiki/Metal_Raiders",
            "http://yugioh.wikia.com/wiki/Spell_Ruler",
            "http://yugioh.wikia.com/wiki/Pharaoh%27s_Servant",
            "http://yugioh.wikia.com/wiki/Labyrinth_of_Nightmare",
            "http://yugioh.wikia.com/wiki/Legacy_of_Darkness",
            "http://yugioh.wikia.com/wiki/Pharaonic_Guardian",
            "http://yugioh.wikia.com/wiki/Magician%27s_Force",
            "http://yugioh.wikia.com/wiki/Dark_Crisis",
            "http://yugioh.wikia.com/wiki/Invasion_of_Chaos",
            "http://yugioh.wikia.com/wiki/Ancient_Sanctuary",

            "http://yugioh.wikia.com/wiki/Soul_of_the_Duelist",
            "http://yugioh.wikia.com/wiki/Rise_of_Destiny",
            "http://yugioh.wikia.com/wiki/Flaming_Eternity",
            "http://yugioh.wikia.com/wiki/The_Lost_Millennium",
            "http://yugioh.wikia.com/wiki/Cybernetic_Revolution",
            "http://yugioh.wikia.com/wiki/Elemental_Energy",
            "http://yugioh.wikia.com/wiki/Shadow_of_Infinity",
            "http://yugioh.wikia.com/wiki/Enemy_of_Justice",

            "http://yugioh.wikia.com/wiki/Power_of_the_Duelist",
            "http://yugioh.wikia.com/wiki/Cyberdark_Impact",
            "http://yugioh.wikia.com/wiki/Strike_of_Neos",
            "http://yugioh.wikia.com/wiki/Force_of_the_Breaker",
            "http://yugioh.wikia.com/wiki/Tactical_Evolution",
            "http://yugioh.wikia.com/wiki/Gladiator%27s_Assault",
            "http://yugioh.wikia.com/wiki/Phantom_Darkness",
            "http://yugioh.wikia.com/wiki/Light_of_Destruction",

            "http://yugioh.wikia.com/wiki/The_Duelist_Genesis",
            "http://yugioh.wikia.com/wiki/Crossroads_of_Chaos",
            "http://yugioh.wikia.com/wiki/Crimson_Crisis",
            "http://yugioh.wikia.com/wiki/Raging_Battle",
            "http://yugioh.wikia.com/wiki/Ancient_Prophecy",
            "http://yugioh.wikia.com/wiki/Stardust_Overdrive",
            "http://yugioh.wikia.com/wiki/Absolute_Powerforce",
            "http://yugioh.wikia.com/wiki/The_Shining_Darkness",

            "http://yugioh.wikia.com/wiki/Duelist_Revolution",
            "http://yugioh.wikia.com/wiki/Starstrike_Blast",
            "http://yugioh.wikia.com/wiki/Storm_of_Ragnarok",
            "http://yugioh.wikia.com/wiki/Extreme_Victory",
            "http://yugioh.wikia.com/wiki/Generation_Force",
            "http://yugioh.wikia.com/wiki/Photon_Shockwave",
            "http://yugioh.wikia.com/wiki/Order_of_Chaos",
            "http://yugioh.wikia.com/wiki/Galactic_Overlord",

            "http://yugioh.wikia.com/wiki/Return_of_the_Duelist",
            "http://yugioh.wikia.com/wiki/Abyss_Rising",
            "http://yugioh.wikia.com/wiki/Cosmo_Blazer",
            "http://yugioh.wikia.com/wiki/Lord_of_the_Tachyon_Galaxy",
            "http://yugioh.wikia.com/wiki/Judgment_of_the_Light",
            "http://yugioh.wikia.com/wiki/Shadow_Specters",
            "http://yugioh.wikia.com/wiki/Legacy_of_the_Valiant",
            "http://yugioh.wikia.com/wiki/Primal_Origin",

            "http://yugioh.wikia.com/wiki/Duelist_Alliance",
            "http://yugioh.wikia.com/wiki/The_New_Challengers",
            "http://yugioh.wikia.com/wiki/Secrets_of_Eternity",
            "http://yugioh.wikia.com/wiki/Crossed_Souls",
            "http://yugioh.wikia.com/wiki/Clash_of_Rebellions",
            "http://yugioh.wikia.com/wiki/Dimension_of_Chaos",
            "http://yugioh.wikia.com/wiki/Breakers_of_Shadow",
            "http://yugioh.wikia.com/wiki/Shining_Victories",
            "http://yugioh.wikia.com/wiki/The_Dark_Illusion",
            "http://yugioh.wikia.com/wiki/Invasion:_Vengeance",
            "http://yugioh.wikia.com/wiki/Raging_Tempest",
            "http://yugioh.wikia.com/wiki/Maximum_Crisis"
        ].map {|url| File.basename(url) }
      end

      def card_db_name_redirect(card_db_name)
        redirects = {
          'Gift_of_the_Mystical_Elf' => 'Gift_of_The_Mystical_Elf',
          'Marie_the_Fallen_One' => 'Darklord_Marie',
          'After_Genocide' => 'After_the_Struggle',
          'Null_and_Void' => 'Muko',
          'Big_Core' => 'B.E.S._Big_Core',
          'Elemental_Hero_Bubbleman' => 'Elemental_HERO_Bubbleman',
          'Elemental_Hero_Neo_Bubbleman' => 'Elemental_HERO_Neo_Bubbleman',
          'Elemental_Hero_Captain_Gold' => 'Elemental_HERO_Captain_Gold',
          'Elemental_Hero_Chaos_Neos' => 'Elemental_HERO_Chaos_Neos',
          'Destiny_Hero_-_Dread_Servant' => 'Destiny_HERO_-_Dread_Servant',
          'Elemental_Hero_Divine_Neos' => 'Elemental_HERO_Divine_Neos',
          'Spider%27s_Lair' => 'Spiders%27_Lair',
          'Elemental_Hero_Ice_Edge' => 'Elemental_HERO_Ice_Edge',
          'Cemetery_Bomb' => 'Cemetary_Bomb',
          'Elemental_Hero_Plasma_Vice' => 'Elemental_HERO_Plasma_Vice',
          'Pigeonholing_Books_of_Spell' => 'Spellbook_Organization',
          'Hidden_Book_of_Spell' => 'Hidden_Spellbook'
        }

        if redirects.has_key?(card_db_name)
          redirects[card_db_name]
        else
          card_db_name
        end
      end
    end
  end
end



# In the TCG, each main series Booster Pack is guaranteed a Rare, 7 Commons,
# and a ninth card which will either be another Common or a foil card (Super Rare rarity or higher).
# As of Breakers of Shadow, the ninth card is guaranteed to be at least a Super Rare, with a 1:6
# chance of it being an Ultra Rare and a 1:12 chance of it being a Secret Rare. This also applies
# to side series sets such as High-Speed Riders and Wing Raiders. Previously, the chances of a
# single pack containing a Super Rare was 1:5, with Ultra Rare and Secret Rare chances being 1:12
# and 1:23; in some older historical sets, the latter two chances were 1:24 and 1:31 instead.[c