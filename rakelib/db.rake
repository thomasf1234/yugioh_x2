# http://www.sqlitetutorial.net/sqlite-dump/
namespace :admin do
  namespace :db do
    desc "dump the database"
    task :dump do
      database = File.basename(database_path)
      dump_path = "db/data/#{ENV['ENV']}/backups/#{timestamp}_#{database}.dump.sql.gz"

      YugiohX2Lib::Utils.system2("sqlite3 #{database_path} \".dump\" | gzip -c9 > #{dump_path}")
      puts "Dumped db #{database_path} to #{dump_path}"
    end

    desc "restore the database from a .dump.gz"
    task :restore, [:backup_path] do |t, args|
      backup_path = args[:backup_path]

      if File.exists?(backup_path)
        if File.exists?(database_path)
          puts "Deleting current database"
          File.delete(database_path)
        end

        YugiohX2Lib::Utils.system2("zcat #{backup_path} | sqlite3 #{database_path}")
        puts "Restored db #{database_path} from #{backup_path}"
      else
        raise "Backup specified cannot be found. Exiting..."
      end
    end

    desc "dump a specific table"
    task :dump_table, [:table] do |t, args|
      table = args[:table]
      dump_path = "db/data/#{ENV['ENV']}/backups/#{timestamp}_#{table}.dump.sql.gz"

      YugiohX2Lib::Utils.system2("sqlite3 #{database_path} \".dump #{table}\" | gzip -c9 > #{dump_path}")
      puts "Dumped table #{database_path} #{table} to #{dump_path}"
    end

    desc "dump a specific table data"
    task :dump_table_data, [:table] do |t, args|
      table = args[:table]
      dest_table = ENV['DEST_TABLE'] || table
      dump_path = "tmp/#{table}.data.dump.sql"
      command = <<EOF
.headers on
.mode insert #{dest_table}
.output #{dump_path}
SELECT * FROM #{table};
.quit
EOF

      YugiohX2Lib::Utils.system2("sqlite3 #{database_path} <<EOF\n#{command}\nEOF")
      puts "Dumped table data from #{database_path} #{table} to #{dump_path}"
    end

    desc "runs database seeds in db/seeds/*.sql"
    task :seed do
      if YugiohX2::Card.count == 0
        seed_paths =  Dir.glob("db/seeds/**/*\.sql")

        seed_paths.each do |seed_path|
          puts "Seeding #{seed_path}..."
          YugiohX2Lib::DBUtils.seed(seed_path)
        end

        puts "Finished seeding #{database_path}."
      else
        puts "Not seeding as database is not empty"
      end
    end

    def timestamp
      DateTime.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def database_path
      YugiohX2Lib::DBUtils.database_path
    end
  end
end