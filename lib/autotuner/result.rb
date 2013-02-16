require 'stringio'
require 'pathname'
require 'sqlite3'
require 'autotuner/logger'

module Autotuner
  class Result
    include Logger
    DB_DIR = Pathname('../../../db').expand_path(__FILE__)

    def initialize(plan)
      @plan = plan
      logger.info "Result table name: #{table_name}"
    end

    def insert(param_name, param_value, actual_value)
      create_table
      query = "INSERT INTO #{table_name} (#{param_name}, value) VALUES (#{param_value}, #{actual_value})"
      db.execute query
    end

    def show(out=$stdout)
      out.puts '-----------'
      out.puts to_tsv
    end

    def to_tsv
      out = StringIO.new
      out.print "id\t"
      out.print @plan.parameters.keys.join("\t")
      out.print "\tvalue\n"
      db.execute("SELECT * FROM #{table_name} ORDER BY id") do |row|
        out.puts row.join("\t")
      end
      out.string
    end

    def table_name
      @table_name ||= "result_#{Time.now.strftime('%Y%m%d%H%M%S')}"
    end

    def create_table
      db.execute create_table_query
    end

    def db
      @db ||= SQLite3::Database.new db_path
    end

    def db_path
      @db_path ||= DB_DIR.join("#{@plan.name}.db").to_s
    end

    private
      def create_table_query
        query = <<-SQL
  CREATE TABLE IF NOT EXISTS #{table_name} (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        SQL

        @plan.parameters.keys.each do |k|
          query += <<-SQL
  #{k} INTEGER NOT NULL,
          SQL
        end

        query += <<-SQL
  value REAL NOT NULL
  )
        SQL
        query
      end
  end
end
