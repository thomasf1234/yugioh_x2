require 'nokogiri'

module YugiohX2Lib
  module ExternalPages
    YUGIOH_WIKIA_URL = 'http://yugioh.wikia.com'
    CARD_GALLERY_URL = YUGIOH_WIKIA_URL + '/wiki/Category:Card_Gallery'
    XPATH_QUOTE = "&apos;"

    class MainPage
      attr_reader :card_db_name, :gallery_page, :card_table

      def initialize(card_db_name)
        @card_db_name = card_db_name
        @page = Nokogiri::HTML(Utils.retry_open("#{ExternalPages::YUGIOH_WIKIA_URL}/wiki/#{@card_db_name}"))

        card_table_element = @page.xpath("//table[@class='cardtable']")
        if card_table_element.empty?
          raise AnimeCardFound
        else
          @card_table = CardTable.new(card_table_element)
          gallery_end_point = @page.xpath("//td[@id='cardtablelinks']").xpath(".//a[contains(@title,'Card Gallery')]").attribute('href').value.strip
          @gallery_page = GalleryPage.new(Nokogiri::HTML(Utils.retry_open(YUGIOH_WIKIA_URL + gallery_end_point)))
        end
      end

      def card_type
        if @card_table.contains_key?('Card type')
          _card_type = @card_table.row_value('Card type').strip

          if _card_type == YugiohX2::Card::Types::MONSTER
            YugiohX2::Card::Types::MONSTER
          else
            YugiohX2::Card::Types::NON_MONSTER
          end
        else
          nil
        end
      end

      def category
        if @card_table.contains_key?('Card type')
          _card_type = @card_table.row_value('Card type').strip
        else
          return nil
        end

        if _card_type == YugiohX2::Card::Types::MONSTER
          _types = types

          if _types.include?(YugiohX2::Card::Categories::PENDULUM)
            YugiohX2::Card::Categories::PENDULUM
          elsif _types.include?(YugiohX2::Card::Categories::FUSION)
            YugiohX2::Card::Categories::FUSION
          elsif _types.include?(YugiohX2::Card::Categories::RITUAL)
            YugiohX2::Card::Categories::RITUAL
          elsif _types.include?(YugiohX2::Card::Categories::SYNCHRO)
            YugiohX2::Card::Categories::SYNCHRO
          elsif _types.include?(YugiohX2::Card::Categories::XYZ)
            YugiohX2::Card::Categories::XYZ
          elsif _types.include?(YugiohX2::Card::Categories::EFFECT)
            YugiohX2::Card::Categories::EFFECT
          elsif _types.include?(YugiohX2::Monster::Abilities::TOON)
            YugiohX2::Card::Categories::EFFECT
          elsif _types.include?(YugiohX2::Monster::Abilities::SPIRIT)
            YugiohX2::Card::Categories::EFFECT
          elsif _types.include?(YugiohX2::Monster::Abilities::GEMINI)
            YugiohX2::Card::Categories::EFFECT
          elsif !card_effect_types.empty?
            YugiohX2::Card::Categories::EFFECT
          else
            YugiohX2::Card::Categories::NORMAL
          end
        else
          if !_card_type.match(YugiohX2::Card::Categories::SPELL).nil?
            YugiohX2::Card::Categories::SPELL
          elsif !_card_type.match(YugiohX2::Card::Categories::TRAP).nil?
            YugiohX2::Card::Categories::TRAP
          else
            raise "Unknown card type"
          end
        end
      end

      def card_name
        if @card_table.contains_key?('English')
          @card_table.row_value('English').strip
        else
          nil
        end
      end

      def level
        if @card_table.contains_key?('Level')
          @card_table.row_value('Level').strip.to_i
        else
          nil
        end
      end

      def rank
        if @card_table.contains_key?('Rank')
          @card_table.row_value('Rank').strip.to_i
        else
          nil
        end
      end

      def pendulum_scale
        if @card_table.contains_key?('Pendulum Scale')
          @card_table.row_value('Pendulum Scale').strip.to_i
        else
          nil
        end
      end

      def attribute
        if @card_table.contains_key?('Attribute')
          @card_table.row_value('Attribute').strip
        else
          nil
        end
      end

      def property
        if @card_table.contains_key?('Property')
          @card_table.row_value('Property').strip
        else
          nil
        end
      end

      def types
        if @card_table.contains_key?('Types')
          @card_table.row_value('Types').split('/').map(&:strip)
        elsif @card_table.contains_key?('Type')
          [@card_table.row_value('Type').strip]
        else
          []
        end
      end

      def attack
        if @card_table.contains_key?('ATK / DEF')
          @card_table.row_value('ATK / DEF').split("/").first.strip
        else
          nil
        end
      end

      def defense
        if @card_table.contains_key?('ATK / DEF')
          @card_table.row_value('ATK / DEF').split("/").last.strip
        else
          nil
        end
      end

      def card_description
        @card_table.get_description
      end

      def serial_number
        if @card_table.contains_key?('Passcode')
          @card_table.row_value('Passcode').strip
        else
          nil
        end
      end

      def card_effect_types
        if @card_table.contains_key?('Card effect types')
          @card_table.row_value('Card effect types').lines.map(&:strip)
        else
          []
        end
      end

      private
      class CardTable
        def initialize(card_table)
          @card_table = card_table
          @rows = @card_table.xpath("./tr[@class='cardtablerow']")
        end

        def row_value(header)
          begin
            @rows.detect do |row|
              row.xpath("./th").text.strip == header
            end.xpath("./td").text.strip
          rescue
          end
        end

        def contains_key?(key)
          @rows.any? do |row|
            row.xpath("./th").text.strip == key
          end
        end

        def get_description
          row = @rows.detect { |row| !row.xpath(".//b[text()='Card descriptions']").empty? }

          if row.nil?
            nil
          else
            child = row.children.first.children.detect do |child|
              !child.xpath(".//div[contains(text(),'English')]").empty? ||
                  !child.xpath(".//a[contains(@title,'Tag Force')]").empty?
            end

            if child.nil?
              return nil
            else
              child.xpath(".//td[@class='navbox-list']").children.inject('') do |result, description_segment|
                result += (description_segment.name == 'br') ? "\n" : description_segment.text
                result
              end.strip
            end
          end
        end
      end
    end
  end
end

