require "active_record"
Dir[File.join(File.dirname(__FILE__), 'rgreek', '*.rb')].each { |file| require file.gsub(".rb", "")}

module RGreek
  database_name = ENV["RGREEK_ENV"] == "test" ? "rgreek_test.sqlite" : "rgreek.sqlite"
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "lib/data/db/#{database_name}"
end
