require 'set'

module YugiohX2Lib
  module ExternalPages
    class GalleryPage
      TAG_FORCE_REGEX = /-TF(0\d|S)-JP-VG(-\d)?\./
      YUGIOH_COM_REGEX = /-OW(-\d)?\./

      attr_reader :image_urls

      def initialize(page)
        @page = page
        @image_urls = Set.new
      end

      def fetch_image_urls
        [TAG_FORCE_REGEX, YUGIOH_COM_REGEX].each do |regex|
          image_elements = @page.xpath("//div[@id='mw-content-text']").xpath(".//img[@class='thumbimage']")

          image_elements.each do |image_element|
            image_url = image_element.attribute('src').value
            @image_urls << image_url.split('/revision').first if image_url.match(regex)
          end
        end

        @image_urls.to_a
      end
    end
  end
end



