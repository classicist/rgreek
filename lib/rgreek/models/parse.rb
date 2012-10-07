module RGreek
class Parse < ActiveRecord::Base       
  belongs_to :lemma
  default_scope order("lemma_id asc").order("dialects desc").order("morph_code asc")
  
    def self.find_parses(word)
      if has_accents?(word)
        find_all_by_form(word)
      else
        find_all_by_bare_form(word)
      end
    end
    
    def self.find_parses_hashed_by_lemma(word)
      parses = find_parses(word)
      parses.inject({}) do |parses_hashed_by_lemma, parse| #assumes parses sorted by lemma_id      
        lemma = Lemma.find(parse.lemma_id)
        parses_hashed_by_lemma[lemma] ? parses_hashed_by_lemma[lemma] << parse : parses_hashed_by_lemma[lemma] = [parse]
        parses_hashed_by_lemma
      end
    end

    def self.has_accents?(word)
      (word =~ /.*\W/) != nil
    end
  
    def english_morph_code
      MorphCode.convert_to_english(morph_code)
    end
    
    def to_s
      "#{id}: #{form}, #{english_morph_code}, lemma_d: #{lemma_id}"
    end
  end
end#EOM