# http://stackoverflow.com/questions/16948645/how-do-i-test-a-function-with-gets-chomp-in-it

namespace :admin do
  namespace :jobs do
    desc "sync cards"
    task :sync_cards do
      stopwatch = YugiohX2Lib::Stopwatch.new

      stopwatch.time_it do
        YugiohX2Lib::Jobs::SyncCards.new.perform
      end
    end
  end
end