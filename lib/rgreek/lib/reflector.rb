module Reflector
  class << self
    attr_reader :lemma_class
  end
  
  def lemma_class(lemma_klass = nil)
    #RGreek::GreekParse -> GreekLemma
    lemma_klass = lemma_klass ? symbol_to_classname(lemma_klass) : toggled_classname
    @lemma_class ||= module_eval(lemma_klass)
  end
  
  def parses_sym
    titlecase_to_sym(pluralize(toggled_classname))
  end
  
  def lemma_sym
    titlecase_to_sym(toggled_classname)
  end

  def symbol_to_classname(sym)
    sym.to_s.capitalize.gsub(/_(\w)/) { $1.upcase }
  end
    
  def titlecase_to_sym(word)
    word.gsub(/(\w)([A-Z])/) {$1 + "_" + $2}.downcase.to_sym
  end
  
  def no_namespace_classname
    self.to_s.to_s.gsub(/.*::/, "")
  end
  
  def swap_lemma_and_parse(klass_name)
    klass_name.include?("Parse") ? klass_name.gsub("Parse", "Lemma") : klass_name.gsub("Lemma", "Parse")
  end
  
  def toggled_classname
    swap_lemma_and_parse(no_namespace_classname)
  end
  
  def pluralize(plural_in_s)
    plural_in_s + "s"
  end
end