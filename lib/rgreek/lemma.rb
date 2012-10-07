module RGreek
class Lemma < ActiveRecord::Base
  has_many :parses
  scope :greek, where("lang_id = 2")
  scope :latin, where("lang_id = 3")
  
  def self.find_all_latin_lacking_short_def
    Lemma.latin.where("short_def is NULL")
  end
  
  def lsj_entry
    LsjEntry.find_by_headword(greek_headword)
  end
  
  def unicode_headword
    greek_headword || headword
  end
  
  def lang
    lang_id == "2" ? "greek" : "latin"
  end  
    
  def to_s
    "#{id}: #{greek_headword} : #{headword} : #{short_def}" 
  end
end#EOC
end#EOM