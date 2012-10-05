module RGreek
class Lemma < ActiveRecord::Base
  has_many :parses
  
  def to_s
    "#{id}: #{greek_headword} : #{headword} : #{short_def}" 
  end
end#EOC
end#EOM