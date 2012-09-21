require "rgreek/version"
require "active_record"

module RGreek
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "db/rgreek.db"

  class Lemma < ActiveRecord::Base; end
  class Parse < ActiveRecord::Base; end
end
