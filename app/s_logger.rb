require 'logger'
require 'singleton'

module YugiohX2
  class SLogger < Logger
    COLOUR_CODES = {
        red: 31,
        green: 32,
        yellow: 33,
    }

    include Singleton
    attr_reader :file_path

    LOG_FILE_PATH = File.expand_path(File.join("log", "#{ENV['LOG']}.log"))

    def initialize
      super(LOG_FILE_PATH)
      @file_path = LOG_FILE_PATH
      ObjectSpace.define_finalizer(self, self.class.method(:finalize).to_proc)
    end

    def self.finalize(id)
      instance.close
    end

    def debug(message, colour=nil)
      super(colorize(message, colour))
    end

    def empty
      File.open(@file_path, 'w') do |file|
        file.truncate(0)
      end
    end

    def colorize(string, colour)
      colour.nil? ? string : "\e[#{COLOUR_CODES[colour]}m#{string}\e[0m"
    end
  end
end