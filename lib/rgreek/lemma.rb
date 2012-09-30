module RGreek
class Lemma < ActiveRecord::Base
  def to_s
    "#{id}: #{greek_headword} : #{headword} : #{short_def}" 
  end
end#EOC
end#EOM