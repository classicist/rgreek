module RGreek
class Parse < ActiveRecord::Base       
  belongs_to :lemma
  
    def self.find_parses(word)
      if has_accents?(word)
        sort find_all_by_form(word)
      else
        sort find_all_by_bare_form(word)
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
    
    def self.sort(results)
     # in-memory sort is required because default_scope order(:dialects) is CRAZY slow for some reason
     # also should be OK because we are only pulling back a handful of records at a time
      results.sort_by { |r| [r.lemma_id, r.dialects || ""] }
    end
  
    def morph_code_pretty
      MorphCode.convert_to_english(morph_code)
    end
  end
end#EOM