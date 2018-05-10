require "singleton"
require 'open-uri'
require 'fileutils'


module YugiohX2
  module Services
    class AssetsService
      PUBLIC_DIR = "public"
      JQUERY_VERSION='3.3.1'

      include Singleton

      def install_jquery
        jquery_url = "https://ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js"
        jquery_dir = File.join(PUBLIC_DIR, "js/jquery", JQUERY_VERSION)
        jquery_path = File.join(jquery_dir, 'jquery.min.js')

        FileUtils.mkdir_p(jquery_dir)
        if !File.exist?(jquery_path)
          download = open(jquery_url)
          IO.copy_stream(download, jquery_path)
        end
      end
    end
  end
end