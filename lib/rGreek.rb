require "rgreek/version"
require "active_record"
require "morph_code"

module RGreek
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "db/rgreek.db"

  class Lemma < ActiveRecord::Base 
  
  end
  
  class Parse < ActiveRecord::Base 
        
    def self.find_parses(word)
      if has_accents?(word)
        sort find_all_by_form(word)
      else
        sort find_all_by_bare_form(word)
      end
    end
    
    def self.has_accents?(word)
      (word =~ /.*\W/) != nil
    end
    
    def self.sort(results)
     # memory sort is required because default_scope order(:dialects) is CRAZY slow for some reason
     # also should be OK because we are only pulling back a handful of parses at a time
      results.sort_by { |r| r.dialects || "" }
    end
  
    def morph_code_pretty
      MorphCode.convert_to_english(morph_code)
    end
  end
end
