module RGreek
class ParseReport
    attr_reader :lemma, :parses
    
    def initialize(lemma, parses = [])
      @lemma  = lemma
      @parses = parses
    end
    
    def self.generate(word)
      @parses = Parse.find_parses_hashed_by_lemma(word)
      @parses.inject([]) do |reports, (lemma, parses)|
        report = ParseReport.new(lemma, parses)
        reports << report
      end
    end
    
    def to_s
      "#{lemma.unicode_headword}: #{lemma.short_def}, " + parses.map { |parse| "#{parse.english_morph_code}" }.join("\n")
    end
end#EOC
end#EOM