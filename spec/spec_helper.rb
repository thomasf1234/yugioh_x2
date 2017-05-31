ENV['ENV'] ||= 'test'
Bundler.require(:default, ENV['ENV'])
require_relative '../application'

factories_path = File.expand_path("../factories",__FILE__)
FactoryGirl.definition_file_paths << factories_path
FactoryGirl.find_definitions

class GlobalHelper
  class << self
    include RSpec::Mocks::ExampleMethods

    def login(username, password)
      accounts_controller = YugiohX2::AccountsController.new
      mock_request = double("Request",
                            content_type: 'application/json',
                            header: {},
                            body: {'username' => username, 'password' => password}.to_json,
                            remote_ip: '127.0.0.1')
      json, response_code = accounts_controller.login(mock_request)

      if response_code == 200
        JSON.parse(json)['uuid']
      else
        raise "An error occurred logging in"
      end
    end

    def reset_tables_and_sequences
      connection = ActiveRecord::Base.connection

      tables = connection.execute("SELECT name FROM sqlite_master WHERE type='table';").map {|raw| raw['name']}
      (tables - ['sqlite_sequence', 'ar_internal_metadata']).each do |table|
        connection.execute("DELETE FROM '#{table}'")
        connection.execute("DELETE from sqlite_sequence where name = '#{table}'")
      end

      connection.execute("VACUUM;")
    end
  end
end

RSpec.configure do |config|
  config.color= true
  config.order= :rand
  config.default_formatter = 'doc'
  config.profile_examples = 10
  config.warnings = true
  config.raise_errors_for_deprecations!
  config.disable_monkey_patching!

  config.before(:suite) do
    YugiohX2::SLogger.instance.empty
  end

  config.before(:each) do
    GlobalHelper.reset_tables_and_sequences
  end
end

