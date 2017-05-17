require 'nokogiri'
require 'fileutils'

module YugiohX2Lib
  module Jobs
    class SyncCards
      def perform
        db_names = fetch_db_names
        db_names.each do |db_name|
          old_card = YugiohX2::Card.find_by_db_name(db_name)

          if old_card.nil?
            begin
              sync_card(db_name)
              YugiohX2::SLogger.instance.debug("Synced #{db_name}", :green)
            rescue => e
              YugiohX2::SLogger.instance.debug("Failed to sync #{db_name}", :red)
              YugiohX2::SLogger.instance.debug("#{e.class.name} : #{e.message}", :red)
              YugiohX2::SLogger.instance.debug(e.backtrace.join("\n"), :red)
            end
          else
            YugiohX2::SLogger.instance.debug("Skipping #{db_name}: Already exists", :yellow)
          end
        end
      end

      def sync_card(db_name)
        main_page = ExternalPages::MainPage.new(db_name)

        card_create_params = {
            db_name: main_page.card_db_name,
            card_type: main_page.card_type,
            category: main_page.category,
            name: main_page.card_name,
            level: main_page.level,
            rank: main_page.rank,
            pendulum_scale: main_page.pendulum_scale,
            card_attribute: main_page.attribute,
            property: main_page.property,
            attack: main_page.attack,
            defense: main_page.defense,
            serial_number: main_page.serial_number,
            description: main_page.card_description,
        }

        card = YugiohX2::Card.create!(card_create_params)

        if card.card_type == YugiohX2::Card::Types::MONSTER
          monster_type_create_params = main_page.types.map do |monster_type_name|
            { name: monster_type_name, card_id: card.id }
          end

          YugiohX2::MonsterType.create!(monster_type_create_params)
        end

        sync_artworks(card, main_page)
      end

      def sync_artworks(card, main_page)
        artwork_dir = File.join(DATA_DIRECTORY, 'artworks', card.db_name)
        FileUtils.mkdir_p(artwork_dir)

        artwork_urls = main_page.gallery_page.fetch_image_urls

        if artwork_urls.empty?
          YugiohX2::SLogger.instance.debug("No artworks for #{card.db_name}", :yellow)
        else
          artwork_urls.each do |artwork_url|
            destination = File.join(artwork_dir, File.basename(artwork_url))
            existing_artwork = YugiohX2::Artwork.find_by_image_path(destination)

            if existing_artwork.nil?
              YugiohX2Lib::Utils.download_url(artwork_url, destination)
              YugiohX2::Artwork.create(card_id: card.id, source_url: artwork_url, image_path: destination)
              YugiohX2::SLogger.instance.debug("Downloaded artwork to #{destination}", :green)
            elsif File.exists?(destination) && !File.zero?(destination)
              YugiohX2Lib::Utils.download_url(artwork_url, destination)
              YugiohX2::SLogger.instance.debug("Downloaded artwork to #{destination}", :green)
            else
              YugiohX2::SLogger.instance.debug("Skipping artwork #{destination} : Already downloaded", :yellow)
            end
          end
        end
      end

      private
      def fetch_db_names
        card_gallery_page = Nokogiri::HTML(Utils.retry_open(ExternalPages::CARD_GALLERY_URL))
        page_count = card_gallery_page.xpath("//a[@class='paginator-page']").last.text.to_i
        page_count = 1

        pages = (1..page_count).map do |page_number|
          card_gallery_url = "#{ExternalPages::CARD_GALLERY_URL}?page=#{page_number}"
          Nokogiri::HTML(Utils.retry_open(card_gallery_url))
        end

        db_names = pages.map do |page|
          page.xpath("//a[contains(@href,'/wiki/Card_Gallery:')]").map do |anchor|
            anchor.attribute('href').value[19..-1]
          end
        end.flatten.compact.uniq.map(&:strip)

        db_names
      end
    end
  end
end