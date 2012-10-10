module RGreek
  class Paradigm
    attr_reader :lemma
    def initialize(lemma)
      @lemma = lemma
    end
    
    def parses
      @lemma.parses
    end
    
    def print
      puts "#{lemma.unicode_headword}: #{lemma.short_def}"      
      parses.each do |parse|
        puts "#{Transcoder.convert(parse.form)}: #{parse.english_morph_code}"
      end
      nil
    end
  end#EOC
end#EOM