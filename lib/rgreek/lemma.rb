module RGreek
class Lemma < ActiveRecord::Base
  def to_greek
    Transcoder.betacode_to_unicode(headword)
  end
end#EOC
end#EOM