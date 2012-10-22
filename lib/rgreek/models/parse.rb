module RGreek

module Parse
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.class_eval do
      include Reflector::InstanceMethods      
      belongs_to klass.lemma_sym          
      default_scope order("lemma_id asc").order("dialects desc").order("morph_code asc")         
    end    
  end
    
  def english_morph_code
    MorphCode.convert_to_english(morph_code)
  end
  
  def to_s
    "#{id}: #{form}, #{english_morph_code}, lemma_id: #{lemma_id}"
  end 
  
  module ClassMethods
     include Reflector

    def find_parses_hashed_by_lemma(word)
      parses = find_parses(word)
      parses.inject({}) do |parses_hashed_by_lemma, parse| #assumes parses sorted by lemma_id      
        lemma = lemma_class.find_by_parse(parse)
        parses_hashed_by_lemma[lemma] ? parses_hashed_by_lemma[lemma] << parse : parses_hashed_by_lemma[lemma] = [parse]
        parses_hashed_by_lemma
      end
    end
  
    def find_parses(word)
      if Transcoder.has_accents?(word)
        find_all_by_form(word)
      else
        find_all_by_bare_form(word)
      end
    end
  end#EOM

end#EOM
  
class GreekParse < ActiveRecord::Base       
  include Parse
end#EOC

class LatinParse < ActiveRecord::Base       
  include Parse
end#EOC
  
end#EOM