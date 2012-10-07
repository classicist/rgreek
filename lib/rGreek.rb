require "active_record"
Dir[File.join(File.dirname(__FILE__), 'rgreek', '**/*.rb')].each { |file| require file.gsub(".rb", "")}

module RGreek
  database_name = ENV["RGREEK_ENV"] == "test" ? "rgreek_test" : "rgreek"
  ActiveRecord::Base.establish_connection adapter: "postgresql", encoding: "unicode", database: database_name, pool: 5, username: "paul", password: ""
end
