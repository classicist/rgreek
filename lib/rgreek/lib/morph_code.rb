module RGreek
  module MorphCode
    
  def self.convert_to_english(code)
    return PARTS_OF_SPEECH[code[0]] + " " + INDECLINABLE if code == INDECLINABLE_CODE
    
    code.split("").each_with_index.map do |letter, index| 
      letter == "-" ? "" : CONVERSION_TABLES[index][letter] + " "
    end.join.rstrip
  end  

INDECLINABLE_CODE = "c--------"
INDECLINABLE = "indeclinable"

PARTS_OF_SPEECH = Hash[     
	  "n" => "noun",
	  "v" => "verb",
	  "t" => "part",
	  "a" => "adj",
	  "d" => "adv",
	  "d" => "adverbial",
	  "l" => "article",
	  "g" => "partic",
	  "c" => "conj",
	  "r" => "prep",
	  "p" => "pron",
	  "m" => "numeral",
	  "i" => "interj",
	  "e" => "exclam",
	  "x" => "irreg"
]
	  	  
PERSON = Hash[ 
	  "1" => "1st",
	  "2" => "2nd",
	  "3" => "3rd"
]
	                              
NUMBER = Hash[ 
	  "s" => "sg",
	  "p" => "pl",
	  "d" => "dual"
]
	  
TENSE = Hash[ 
	  "p" => "pres",
	  "i" => "imperf",
	  "r" => "perf",
	  "l" => "plup",
	  "t" => "futperf",
	  "f" => "fut",
	  "a" => "aor"
]
	
MOOD = Hash[ 
	  "i" => "ind",
	  "s" => "subj",
	  "o" => "opt",
	  "n" => "inf",
	  "m" => "imperat",
	  "g" => "gerundive",
	  "p" => "supine"
]

VOICE = Hash[ 
	  "a" => "act",
	  "p" => "pass",
	  "d" => "dep",
	  "m" => "mid",
	  "e" => "mp"
]

GENDER = Hash[ 
	  "m" => "masc",
	  "f" => "fem",
	  "n" => "neut"
]
	  
CASE = Hash[ 
	  "n" => "nom",
	  "g" => "gen",
	  "d" => "dat",
	  "a" => "acc",
	  "b" => "abl",
	  "v" => "voc",
	  "l" => "loc",
	  "i" => "ins"
]
	  
DEGREE = Hash[ 
	  "p" => "pos",
	  "c" => "comp",
	  "s" => "superl"
]		

  CONVERSION_TABLES = [PARTS_OF_SPEECH, PERSON, NUMBER, TENSE, MOOD, VOICE, GENDER, CASE, DEGREE]
  end
  
#  class FlatMorphCodes
#    PART_OF_SPEECH = "pos"     
#	  NOUN = "noun"               => "n"
#	  VERB = "verb"               => "v"
#	  PARTICIPLE = "part"         => "t"
#	  ADJECTIVE = "adj"           => "a"
#	  ADVERB = "adv"              => "d"
#	  ADVERBIAL = "adverbial"     => "d"
#	  ARTICLE = "article"         => "l"
#	  PARTICLE = "partic"         => "g"
#	  CONJUNCTION = "conj"        => "c"
#	  PREPOSITION = "prep"        => "r"
#	  PRONOUN = "pron"            => "p"
#	  NUMERAL = "numeral"         => "m"
#	  INTERJECTION = "interj"     => "i"
#	  EXCLAMATION = "exclam"      => "e"
#	  IRREGULAR = "irreg"         => "x"
#    PUNCTUATION = "punc"    	  
#	  FUNCTIONAL = "func"
#	  
#	  	  
#	  PERSON = "person"
#	  FIRST_PERSON = "1st"        => "1"
#	  SECOND_PERSON = "2nd"       => "2"
#	  THIRD_PERSON = "3rd"        => "3"
#	                              
#	  NUMBER = "number"           
#	  SINGULAR = "sg"             => "s"
#	  PLURAL = "pl"               => "p"
#	  DUAL = "dual"               => "d"
#	  
#	  TENSE = "tense"
#	  PRESENT = "pres"            => "p"
#	  IMPERFECT = "imperf"        => "i"
#	  PERFECT = "perf"            => "r"
#	  PLUPERFECT = "plup"         => "l"
#	  FUTURE_PERFECT = "futperf"  => "t"
#	  FUTURE = "fut"              => "f"
#	  AORIST = "aor"              => "a"
#	  PAST_ABSOLUTE = "pastabs"
#	  
#	  MOOD = "mood"
#	  INDICATIVE = "ind"          => "i"
#	  SUBJUNCTIVE = "subj"        => "s"
#	  OPTATIVE = "opt"            => "o"
#	  INFINITIVE = "inf"          => "n"
#	  IMPERATIVE = "imperat"      => "m"
#	  GERUNDIVE = "gerundive"     => "g"
#	  SUPINE = "supine"           => "p"
#	  
#	  VOICE = "voice"
#	  ACTIVE = "act"              => "a"
#	  PASSIVE = "pass"            => "p"
#	  DEPONENT = "dep"            => "d"
#	  MIDDLE = "mid"              => "m"
#	  MEDIO_PASSIVE = "mp"        => "e"
#	  
### NOUNS / ADJS
#	  GENDER = "gender"
#	  MASCULINE = "masc"          => "m"
#	  FEMININE = "fem"            => "f"
#	  NEUTER = "neut"             => "n"
#	  
#	  CASE = "case"
#	  NOMINATIVE = "nom"          => "n"
#	  GENITIVE = "gen"            => "g"
#	  DATIVE = "dat"              => "d"
#	  ACCUSATIVE = "acc"          => "a"
#	  ABLATIVE = "abl"            => "b"
#	  VOCATIVE = "voc"            => "v"
#	  LOCATIVE = "loc"            => "l"
#	  INSTRUMENTAL = "ins"        => "i"
#	  
#	  DEGREE = "degree"
#	  POSITIVE = "pos"            => "p"
#	  COMPARATIVE = "comp"        => "c"
#	  SUPERLATIVE = "superl"      => "s"
#	  
#	  DIALECT = "dialect"
#	  AEOLIC = "aeolic"
#	  ATTIC = "attic"
#	  DORIC = "doric"
#	  EPIC = "epic"
#	  HOMERIC = "homeric"
#	  IONIC = "ionic"
#	  PARADIGM_FORM = "parad_form"
#	  PROSE = "prose"
#	  POETIC = "poetic"			
#	end
end