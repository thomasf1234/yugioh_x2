require "singleton"
require 'open-uri'
require 'fileutils'


module YugiohX2
  module Services
    class AssetsService
      PUBLIC_DIR = "app/controllers/public"

      include Singleton

      def install_jquery(version)
        jquery_url = File.join("https://ajax.googleapis.com/ajax/libs/jquery", version, "/jquery.min.js")
        jquery_dir = File.join(PUBLIC_DIR, "js/jquery", version)
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