module Reflector
  class << self
    attr_reader :lemma_class
  end
  
  def lemma_class(lemma_klass = nil)
    #RGreek::GreekParse -> GreekLemma
    lemma_klass = lemma_klass ? symbol_to_qualified_classname(lemma_klass) : self.to_s.gsub("Parse", "Lemma").gsub(/.*::/, "")
    @lemma_class ||= module_eval(lemma_klass)
  end
  
  def symbol_to_qualified_classname(sym)
    namespace + "::" + sym.to_s.capitalize.gsub(/_(\w)/) { $1.upcase }
  end
  
  def namespace
    to_s.gsub(/^(.*)::.*/, '\1')
  end
  
  def to_parse_sym
    self.to_s.gsub(/.*::/, "").gsub("Lemma", "Parse").gsub(/(\w)([A-Z])/) {$1 + "_" + $2}.downcase.to_sym
  end
end