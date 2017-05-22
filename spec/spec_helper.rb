ENV['ENV'] ||= 'test'
Bundler.require(:default, ENV['ENV'])
require_relative '../application'

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
    tables = ActiveRecord::Base.connection.execute("SELECT name FROM sqlite_master WHERE type='table';").map {|raw| raw['name']}
    (tables - ['sqlite_sequence', 'ar_internal_metadata']).each do |table|
      ActiveRecord::Base.connection.execute("DELETE FROM #{table};")
    end
    ActiveRecord::Base.connection.execute("VACUUM;")
  end
end