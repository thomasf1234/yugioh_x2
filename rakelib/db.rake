# http://www.sqlitetutorial.net/sqlite-dump/
namespace :admin do
  namespace :db do
    desc "dump the database"
    task :dump do
      database_path = ActiveRecord::Base.connection_config[:database]
      database_name = File.basename(database_path)
      dump_result = system("sqlite3 #{database_path} \".dump\" > tmp/#{database_name}.dump.sql")

      if dump_result == true
        puts "Dumped database #{database_path} to tmp/#{database_name}.dump.sql"
      else
        raise YugiohX2::YugiohError.new("An error occurred dumping database #{database_name}")
      end
    end

    desc "dump a specific table"
    task :dump_table, [:table] do |t, args|
      table = args[:table]
      database_path = ActiveRecord::Base.connection_config[:database]
      dump_result = system("sqlite3 #{database_path} \".dump #{table}\" > tmp/#{table}.dump.sql")

      if dump_result == true
        puts "Dumped table data #{database_path} #{table} to tmp/#{table}.sql"
      else
        raise YugiohX2::YugiohError.new("An error occurred dumping table #{table}")
      end
    end

    desc "dump a specific table data"
    task :dump_table_data, [:table] do |t, args|
      table = args[:table]
      dest_table = ENV['DEST_TABLE'] || table
      database_path = ActiveRecord::Base.connection_config[:database]
       dump_path = "tmp/#{table}.dump.sql"

      command = <<EOF
.headers on
.mode insert #{dest_table}
.output #{dump_path}
SELECT * FROM #{table};
.quit
EOF
      dump_result = system("sqlite3 #{database_path} <<EOF\n#{command}\nEOF")

      if dump_result == true
        puts "Dumped table data #{database_path} #{table} to #{dump_path}"
      else
        raise YugiohX2::YugiohError.new("An error occurred dumping table #{table}")
      end
    end
  end
end