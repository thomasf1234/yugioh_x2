require 'logger'
require 'singleton'

module YugiohX2
  class SLogger < Logger
    include Singleton
    attr_reader :file_path

    LOG_FILE_PATH = File.expand_path(File.join("log", "#{ENV['ENV']}.log"))

    def initialize
      super(LOG_FILE_PATH)
      @file_path = LOG_FILE_PATH
      ObjectSpace.define_finalizer(self, self.class.method(:finalize).to_proc)
    end

    def self.finalize(id)
      instance.close
    end

    def empty
      File.open(@file_path, 'w') do |file|
        file.truncate(0)
      end
    end
  end
end