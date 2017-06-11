require 'nokogiri'
require 'fileutils'

#TODO : card validations on properties, types, category inclusion and testing

module YugiohX2Lib
  module Jobs
    class SyncCards
      def perform
        db_names = fetch_db_names
        db_names.each do |db_name|
          sync(db_name)
        end
      end

      def sync(db_name)
        Ax1Utils::SLogger.instance.info($log_name, "***************Starting sync for #{db_name}")

        if YugiohX2::Card.exists?(db_name: db_name)
          Ax1Utils::SLogger.instance.warn($log_name, "Skipping #{db_name}: Already exists")
        else
          if YugiohX2::UnusableCard.exists?(db_name: db_name)
            Ax1Utils::SLogger.instance.warn($log_name, "Skipping #{db_name}: Unusable card")
          else
            begin
              ActiveRecord::Base.transaction do
                sync_card(db_name)
              end

              if YugiohX2::Card.exists?(db_name: db_name)
                Ax1Utils::SLogger.instance.success($log_name, "Successfully synced #{db_name}")
              else
                Ax1Utils::SLogger.instance.warn($log_name, "Rollback for #{db_name}")
              end
            rescue YugiohX2Lib::AnimeCardFound
              YugiohX2::UnusableCard.create!(db_name: db_name, reason: "Anime Card")
              Ax1Utils::SLogger.instance.warn($log_name, "Skipping #{db_name}: Anime Card")
            rescue ActiveRecord::RecordInvalid => rie
              YugiohX2::UnusableCard.create!(db_name: db_name, reason: "#{rie.class.name} : #{rie.message}")
              Ax1Utils::SLogger.instance.warn($log_name, "Skipping #{db_name}: #{rie.class.name} : #{rie.message}")
            rescue => e
              Ax1Utils::SLogger.instance.error($log_name, "Failed to sync #{db_name}")
              Ax1Utils::SLogger.instance.error($log_name, "#{e.class.name} : #{e.message}")
              Ax1Utils::SLogger.instance.error($log_name, e.backtrace.join("\n"))
            end
          end
        end

        Ax1Utils::SLogger.instance.info($log_name, "***************Finished sync for #{db_name}")
      end

      private
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
          Ax1Utils::SLogger.instance.warn($log_name, "No artworks for #{card.db_name}")
        else
          artwork_urls.each do |artwork_url|
            destination = File.join(artwork_dir, File.basename(artwork_url))
            existing_artwork = YugiohX2::Artwork.find_by_image_path(destination)

            if existing_artwork.nil?
              YugiohX2Lib::Utils.download_url(artwork_url, destination)
              YugiohX2::Artwork.create(card_id: card.id, source_url: artwork_url, image_path: destination)
              Ax1Utils::SLogger.instance.success($log_name, "Downloaded artwork to #{destination}")
            elsif File.exists?(destination) && !File.zero?(destination)
              YugiohX2Lib::Utils.download_url(artwork_url, destination)
              Ax1Utils::SLogger.instance.success($log_name, "Downloaded artwork to #{destination}")
            else
              Ax1Utils::SLogger.instance.warn($log_name, "Skipping artwork #{destination} : Already downloaded")
            end
          end
        end
      end

      private
      def fetch_db_names
        card_gallery_page = Nokogiri::HTML(Utils.retry_open(ExternalPages::CARD_GALLERY_URL))
        page_count = card_gallery_page.xpath("//a[@class='paginator-page']").last.text.to_i

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