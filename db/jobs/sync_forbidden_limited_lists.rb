require 'nokogiri'
require 'fileutils'

#TODO : card validations on properties, types, category inclusion and testing

module YugiohX2Lib
  module Jobs
    class SyncForbiddenLimitedLists
      MAR_2017 = "http://www.yugioh-card.com/en/limited/Mar_2017.html"
      CURRENT_URL = "http://www.yugioh-card.com/en/limited/"

      def perform
        [MAR_2017, CURRENT_URL].each do |url|
          sync(url)
        end
      end

      def sync(url)
        page = Nokogiri::HTML(YugiohX2Lib::Utils.retry_open(url))
        effective_from_raw = page.xpath("//td[contains(text(), 'FORBIDDEN & LIMITED')]").text.split[-3..-1].join('/').gsub(",", "")
        effective_from = Date.parse(effective_from_raw)

        rows = page.xpath("//tr[contains(@class, 'cardlist_')]").reject do |element|
          element.attr('class') == 'cardlist_atitle'
        end

        begin
          ActiveRecord::Base.transaction do
            forbidden_limited_list = YugiohX2::ForbiddenLimitedList.create!(effective_from: effective_from)

            rows.map {|tr| tr.xpath("./td")}.each do |tds|
              name = format(tds[1].text)
              limited_status = format(tds[2].text)

              if YugiohX2::ForbiddenLimitedListCard::LimitedStatus::ALL.include?(limited_status)
                cards = find_cards(name)

                if cards.empty?
                  raise "Card not found! forbidden_limited_name: #{name}"
                else
                  cards.each do |card|
                    forbidden_limited_list_create_params = {forbidden_limited_list_id: forbidden_limited_list.id,
                                                            card_id: card.id,
                                                            limited_status: limited_status}

                    YugiohX2::ForbiddenLimitedListCard.create!(forbidden_limited_list_create_params)
                    YugiohX2::SLogger.instance.debug("Syncing card: #{name}, card_id: #{card.id}, card_name: #{card.name}, limited_status valid: #{limited_status}", :green)
                  end
                end
              else
                YugiohX2::SLogger.instance.debug("Skipping card #{name}, limited_status not valid: #{limited_status}", :yellow)
              end
            end

            YugiohX2::SLogger.instance.debug("Downloaded #{forbidden_limited_list.forbidden_limited_list_cards.count} forbidden limited list effective from #{effective_from}", :green)
          end
        rescue => e
          YugiohX2::SLogger.instance.debug("Failed to sync #{effective_from}", :red)
          YugiohX2::SLogger.instance.debug("#{e.class.name} : #{e.message}", :red)
          YugiohX2::SLogger.instance.debug(e.backtrace.join("\n"), :red)
        end
      end

      private
      def find_cards(name)
        sql_escaped_name = name.gsub("'", "''").split(" ").join(" ").strip
        YugiohX2::Card.where("UPPER(name) = '#{sql_escaped_name}'")
      end

      def format(string)
        bad_hyphen = [8208].pack('U')
        good_hyphen = [45].pack('U')
        string.gsub(bad_hyphen, good_hyphen).gsub(/\A\p{Space}*|\p{Space}*\z/, '')
      end
    end
  end
end