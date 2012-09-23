require "active_record"
Dir[File.join(File.dirname(__FILE__), 'rgreek', '*.rb')].each { |file| require file.gsub(".rb", "")}

module RGreek
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "lib/db/rgreek.db"
end
