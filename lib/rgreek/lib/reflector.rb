module Reflector
  def lemma_class(lemma_klass = nil)
    #RGreek::GreekParse -> GreekLemma
    lemma_klass = self.to_s.gsub("Parse", "Lemma").gsub(/.*::/, "")
    #lemma_klass = lemma_klass ? symbol_to_qualified_classname(lemma_klass) : self.to_s.gsub("Parse", "Lemma").gsub(/.*::/, "")
    #puts "#{self.to_s} -> #{lemma_klass}"
    const_get(lemma_klass)
  end
  
  def symbol_to_qualified_classname(sym)
    namespace + "::" + sym.to_s.split("_").collect(&:capitalize).join
  end
  
  def namespace
    to_s.gsub(/^(.*)::.*/, '\1')
  end
end