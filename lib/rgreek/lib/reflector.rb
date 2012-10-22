module Reflector
  def lemma_class(lemma_klass = nil)
    #RGreek::GreekParse -> GreekLemma
    const_get(self.to_s.gsub(/.*?::/, "").gsub("Parse", "Lemma"), true)
  end
end