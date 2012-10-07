module RGreek
class Lemma < ActiveRecord::Base
  has_many :parses
  scope :greek, where("lang_id = 2")
  scope :latin, where("lang_id = 3")
  
  def self.find_all_greek_lacking_short_def
    Lemma.greek.where("short_def is NULL")
  end
  
  def lsj_entry
    LsjEntry.find_by_headword(greek_headword)
  end
    
  def to_s
    "#{id}: #{greek_headword} : #{headword} : #{short_def}" 
  end
end#EOC
end#EOM