module RGreek
  
module Lemma
  def self.included(klass)
    klass.extend(ClassMethods)
  end
  
  module ClassMethods
    def find_all_lacking_short_def
      self.where("short_def is NULL")
    end
    
    def find_by_parse(parse)
      self.find(parse.lemma_id)
    end
  end#EOM
end#EOM

class GreekLemma < ActiveRecord::Base
  include Lemma
  has_many :greek_parses, :foreign_key => "lemma_id"  
  alias :parses :greek_parses
  
  def lsj_entry
    LsjEntry.find_by_headword(greek_headword)
  end
  
  def to_s
    "#{id}: #{greek_headword} : #{headword} : #{short_def}" 
  end
end#EOC

class LatinLemma < ActiveRecord::Base
  include Lemma
  has_many :latin_parses, :foreign_key => "lemma_id"
  alias :parses :latin_parses

  def to_s
    "#{id}: #{headword} : #{short_def}" 
  end
end#EOC

end#EOM
