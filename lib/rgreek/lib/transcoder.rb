# encoding: UTF-8

module RGreek
  module Transcoder
    
    def self.convert(code)
      if is_betacode?(code)
        betacode_to_unicode(code)
      elsif is_unicode?(code)
        unicode_to_betacode(code)
      else
        raise "#{code} is neither valid unicode nor betacode -- let's try to keep it clean fellahs"
      end
    end

    def self.tonos_to_oxia(tonos)
      tonos.split("").map{ |char| TONOS_TO_OXIA_TABLE[char] || char }.join("")
    end

    def self.oxia_to_tonos(oxia)
      oxia.split("").map{ |char| OXIA_TO_TONOS_TABLE[char] || char }.join("")
    end

private   
    def self.is_tonos(char)
      char >= 0x03ac && char < 0x03cf
    end
    
    def self.betacode_to_unicode(betacode)
      betacode_tokens = tokenize(betacode)
      convert_to_unicode(betacode_tokens)
    end
    
    def self.unicode_to_betacode(unicode)
      unicode.split("").map do |unichar|
        beta_token = REVERSE_UNICODES[unichar]
        beta_token.split("_").map { |token| selectively_clean_betacode REVERSE_BETA_CODES[token] }
      end.join.downcase
    end
    
    def self.name_of_unicode_char(unicode)
      REVERSE_UNICODES[unicode]
    end
    
    def self.selectively_clean_betacode(betacode) 
      betacode.gsub("s2", "s")  #return "s" for final sigma code bc we prefer to tell final sigma by position to by unique S2 code
    end
    
    def self.convert_to_unicode(betacode_tokens)
      current_index = 0
      unicode = ""
      while current_index < betacode_tokens.length #while loop is necessary to do index adjustmnet for making precombined accents
        code = betacode_tokens[current_index]
        combined_characters = combine_characters(code, current_index, betacode_tokens)
        current_index = index_adjusted_for_combined_characters(combined_characters[:last_index], current_index)
        unicode << lookup_unicode(combined_characters[:code])
      end 
      unicode
    end
        
    def self.combine_characters(code, index, codes)
      next_index = index + 1
      next_index_in_bounds = codes.length - 1 >= next_index
      return {code: code, last_index: index} unless next_index_in_bounds
      
      next_code        = codes[next_index]
      combined_code    = code + "_" + next_code
      it_combines = lookup_unicode(combined_code) != nil
      
      if it_combines
        return combine_characters(combined_code, next_index, codes)
      else 
        return {code: code, last_index: index}
      end
    end
    
    def self.index_adjusted_for_combined_characters(last_index, current_index)
        iterations = last_index - current_index
        current_index += iterations if iterations > 0
        current_index += 1
        current_index      
    end

    LETTER = /[a-zA-Z ]/    
    def self.tokenize(betacode)
      current_index = 0
      betacode.split("").map do |current_char|
        penultimate_char    = current_index - 1 > 0               ? betacode[current_index - 2] : ""   
        last_char           = current_index     > 0               ? betacode[current_index - 1] : ""
        next_char           = current_index     < betacode.length ? betacode[current_index + 1] : ""

        is_capital          = match?(current_char, LETTER) && match?(last_char, /\*/) && !match?(next_char, /\d/)
        is_final_sigma      = match?(current_char, /[sS]/)    && (next_char == nil || match?(next_char, /\W/)) && !is_capital                            
        is_letter           = match?(current_char, LETTER) && !isBetaCodePrefix(last_char) && !match?(next_char, /\d/) && !is_final_sigma
        is_diacrital        = isBetaCodeDiacritical(current_char)
        is_crazy_sigma      = match?(current_char, /\d/) && match?(last_char, /[sS]/) 
        is_kop_or_samp      = match?(current_char, /\d/) && match?(last_char, /#/) 
        is_punctuation      = match?(current_char, /[\#\:\;\'\,\.\-]/) && !match?(next_char, /\d/)
        is_a_bracket        = match?(current_char, /\[|\]/)
        is_a_crux           = match?(current_char, /\%/) && !match?(next_char, /\d/)
        is_a_critical_mark  = match?(current_char, /\d/) && match?(last_char, /\%/) && !match?(next_char, /\d/)        
        
        current_index += 1

        if is_letter || is_punctuation || is_diacrital || is_a_crux          
           lookup_betacode(current_char)
         elsif is_final_sigma
           lookup_betacode("s2") #looked up by position or value
        elsif is_capital || is_a_critical_mark
           lookup_betacode(last_char + current_char)
        elsif is_crazy_sigma || is_kop_or_samp
          token = last_char + current_char
          token = penultimate_char + token if match?(penultimate_char, /\*/)
          lookup_betacode(token)
        elsif is_a_bracket
          token = current_char
          token += next_char if match?(next_char, /\d/)
          lookup_betacode(token)
        end
      end.compact
    end
    
    def self.is_betacode?(code)
      tokens = tokenize(code)
      !(tokens - SHARED_TOKENS).empty?
    end
    
    def self.is_unicode?(code)
      code.split("").detect{ |char| !UNICODES.values.include?(char) }.nil?
    end
    
    def self.lookup_betacode(code)
      BETA_CODES[code.downcase] 
    end
    
    def self.lookup_unicode(code)
      UNICODES[code] #don't skrew with the case, the hash is case sensitive
    end
    
    def self.match?(char, pattern)
      (char =~ pattern) != nil
    end
    
    def self.isBetaCodeDiacritical(code)
        [')', '(', '/', '\\', '=', '+', '|'].include?(code)
    end
    
    def self.isBetaCodePrefix(code)
        ['*', '#', '%'].include?(code)  
    end
  
BETA_CODES = Hash[
"a" => "alpha",
"b" => "beta",
"g" => "gamma",
"d" => "delta",
"e" => "epsilon",
"z" => "zeta",
"h" => "eta",
"q" => "theta",
"i" => "iota",
"k" => "kappa",
"l" => "lambda",
"m" => "mu",
"n" => "nu",
"c" => "xi",
"o" => "omicron",
"p" => "pi",
"r" => "rho",
"s" => "sigmaMedial",
"t" => "tau",
"u" => "upsilon",
"f" => "phi",
"x" => "chi",
"y" => "psi",
"w" => "omega",
"v" => "digamma",
 
"*a" => "Alpha", #captials
"*b" => "Beta",
"*g" => "Gamma",
"*d" => "Delta",
"*e" => "Epsilon",
"*z" => "Zeta",
"*h" => "Eta",
"*q" => "Theta",
"*i" => "Iota",
"*k" => "Kappa",
"*l" => "Lambda",
"*m" => "Mu",
"*n" => "Nu",
"*c" => "Xi",
"*o" => "Omicron",
"*p" => "Pi",
"*r" => "Rho",
"*s" => "Sigma",
"*t" => "Tau",
"*u" => "Upsilon",
"*f" => "Phi",
"*x" => "Chi",
"*y" => "Psi",
"*w" => "Omega",
"*v" => "Digamma",
 
"/" => "oxy",   #lone acute
"\\" => "bary", #lone grave 
"\=" => "peri", #lone circumflex
")" => "lenis", #lone smooth breathing 
"(" => "asper", #lone rough breathing
"+" => "diaer", #lone diaeresis
"|" => "isub",  #pipe for iota subscript
 
" " => "space",
"%" => "crux",
"%2" => "asterisk",
"%5" => "longVerticalBar",
 
"s2" => "sigmaFinal",
"s3" => "sigmaLunate",
"*s3" => "SigmaLunate",
 
"#2" => "stigma",
"*#2" => "Stigma",
"#3" => "koppa",
"*#3" => "Koppa",
"#5" => "sampi",
"*#5" => "Sampi",
 
"#" => "prime",
"\:" => "raisedDot",
";" => "semicolon",
"\u0027" => "elisionMark", #apostrophe; should change to koronis \u1fbd
"," => "comma",
"." => "period",
"-" => "hyphen",
 
"[" => "openingSquareBracket",
"]" => "closingSquareBracket",
"[1" => "openingParentheses",
"]1" => "closingParentheses",
"[2" => "openingAngleBracket",
"]2" => "closingAngleBracket",
"[3" => "openingCurlyBracket",
"]3" => "closingCurlyBracket",
"[4" => "openingDoubleSquareBracket",
"]4" => "closingDoubleSquareBracket"
]

UNICODES = Hash[
"alpha" => "\u03B1",
"beta" => "\u03B2",
"gamma" => "\u03B3",
"delta" => "\u03B4",
"epsilon" => "\u03B5",
"zeta" => "\u03B6",
"eta" => "\u03B7",
"theta" => "\u03B8",
"iota" => "\u03B9",
"kappa" => "\u03BA",
"lambda" => "\u03BB",
"mu" => "\u03BC",
"nu" => "\u03BD",
"xi" => "\u03BE",
"omicron" => "\u03BF",
"pi" => "\u03C0",
"rho" => "\u03C1",
"tau" => "\u03C4",
"upsilon" => "\u03C5",
"phi" => "\u03C6",
"chi" => "\u03C7",
"psi" => "\u03C8",
"omega" => "\u03C9",
"Alpha" => "\u0391",
"Beta" => "\u0392",
"Gamma" => "\u0393",
"Delta" => "\u0394",
"Epsilon" => "\u0395",
"Zeta" => "\u0396",
"Eta" => "\u0397",
"Theta" => "\u0398",
"Iota" => "\u0399",
"Kappa" => "\u039A",
"Lambda" => "\u039B",
"Mu" => "\u039C",
"Nu" => "\u039D",
"Xi" => "\u039E",
"Omicron" => "\u039F",
"Pi" => "\u03A0",
"Rho" => "\u03A1",
"Sigma" => "\u03A3",
"Tau" => "\u03A4",
"Upsilon" => "\u03A5",
"Phi" => "\u03A6",
"Chi" => "\u03A7",
"Psi" => "\u03A8",
"Omega" => "\u03A9",
"digamma" => "\u03DD",
"Digamma" => "\u03DC",
"koppa" => "\u03DF",
"Koppa" => "\u03DE",
"sampi" => "\u03E1",
"Sampi" => "\u03E0",
"stigma" => "\u03DB",
"Stigma" => "\u03DA",

"oxy"   => "\u1FFD",
"bary"  => "\u1FEF",
"peri"  => "\u1FC0",
"lenis" => "\u1FBF",
"asper" => "\u1FFE",
"diaer" => "\u00A8",
"isub" => "\u1FBE",

"lenis_oxy" => "\u1FCE",
"lenis_bary" => "\u1FCD",
"lenis_peri" => "\u1FCF",
"asper_oxy" => "\u1FDE",
"asper_bary" => "\u1FDD",
"asper_peri" => "\u1FDF",
"diaer_oxy" => "\u1FEE",
"diaer_bary" => "\u1FED",
"diaer_peri" => "\u1FC1",

"sigmaMedial" => "\u03C3",
"sigmaFinal" => "\u03C2",
"sigmaLunate" => "\u03F2",
"SigmaLunate" => "\u03F9",

"rho_asper" => "\u1FE5",
"Rho_asper" => "\u1FEC",
"rho_lenis" => "\u1FE4",

"alpha_oxy" => "\u1F71",
"alpha_bary" => "\u1F70",
"alpha_peri" => "\u1FB6",
"alpha_lenis" => "\u1F00",
"alpha_asper" => "\u1F01",
"alpha_lenis_oxy" => "\u1F04",
"alpha_asper_oxy" => "\u1F05",
"alpha_lenis_bary" => "\u1F02",
"alpha_asper_bary" => "\u1F03",
"alpha_lenis_peri" => "\u1F06",
"alpha_asper_peri" => "\u1F07",
"Alpha_oxy" => "\u1FBB",
"Alpha_bary" => "\u1FBA",
"Alpha_lenis" => "\u1F08",
"Alpha_asper" => "\u1F09",
"Alpha_lenis_oxy" => "\u1F0C",
"Alpha_asper_oxy" => "\u1F0D",
"Alpha_lenis_bary" => "\u1F0A",
"Alpha_asper_bary" => "\u1F0B",
"Alpha_lenis_peri" => "\u1F0E",
"Alpha_asper_peri" => "\u1F0F",
"alpha_isub" => "\u1FB3",
"alpha_oxy_isub" => "\u1FB4",
"alpha_bary_isub" => "\u1FB2",
"alpha_peri_isub" => "\u1FB7",
"alpha_lenis_isub" => "\u1F80",
"alpha_asper_isub" => "\u1F81",
"alpha_lenis_oxy_isub" => "\u1F84",
"alpha_asper_oxy_isub" => "\u1F85",
"alpha_lenis_bary_isub" => "\u1F82",
"alpha_asper_bary_isub" => "\u1F83",
"alpha_lenis_peri_isub" => "\u1F86",
"alpha_asper_peri_isub" => "\u1F87",
"Alpha_isub" => "\u1FBC",
"Alpha_lenis_isub" => "\u1F88",
"Alpha_asper_isub" => "\u1F89",
"Alpha_lenis_oxy_isub" => "\u1F8C",
"Alpha_asper_oxy_isub" => "\u1F8D",
"Alpha_lenis_bary_isub" => "\u1F8A",
"Alpha_asper_bary_isub" => "\u1F8B",
"Alpha_lenis_peri_isub" => "\u1F8E",
"Alpha_asper_peri_isub" => "\u1F8F",
"epsilon_oxy" => "\u1F73",
"epsilon_bary" => "\u1F72",
"epsilon_lenis" => "\u1F10",
"epsilon_asper" => "\u1F11",
"epsilon_lenis_oxy" => "\u1F14",
"epsilon_asper_oxy" => "\u1F15",
"epsilon_lenis_bary" => "\u1F12",
"epsilon_asper_bary" => "\u1F13",
"Epsilon_oxy" => "\u1FC9",
"Epsilon_bary" => "\u1FC8",
"Epsilon_lenis" => "\u1F18",
"Epsilon_asper" => "\u1F19",
"Epsilon_lenis_oxy" => "\u1F1C",
"Epsilon_asper_oxy" => "\u1F1D",
"Epsilon_lenis_bary" => "\u1F1A",
"Epsilon_asper_bary" => "\u1F1B",
"eta_oxy" => "\u1F75",
"eta_bary" => "\u1F74",
"eta_peri" => "\u1FC6",
"eta_lenis" => "\u1F20",
"eta_asper" => "\u1F21",
"eta_lenis_oxy" => "\u1F24",
"eta_asper_oxy" => "\u1F25",
"eta_lenis_bary" => "\u1F22",
"eta_asper_bary" => "\u1F23",
"eta_lenis_peri" => "\u1F26",
"eta_asper_peri" => "\u1F27",
"Eta_oxy" => "\u1FCB",
"Eta_bary" => "\u1FCA",
"Eta_lenis" => "\u1F28",
"Eta_asper" => "\u1F29",
"Eta_lenis_oxy" => "\u1F2C",
"Eta_asper_oxy" => "\u1F2D",
"Eta_lenis_bary" => "\u1F2A",
"Eta_asper_bary" => "\u1F2B",
"Eta_lenis_peri" => "\u1F2E",
"Eta_asper_peri" => "\u1F2F",
"eta_isub" => "\u1FC3",
"eta_oxy_isub" => "\u1FC4",
"eta_bary_isub" => "\u1FC2",
"eta_peri_isub" => "\u1FC7",
"eta_lenis_isub" => "\u1F90",
"eta_asper_isub" => "\u1F91",
"eta_lenis_oxy_isub" => "\u1F94",
"eta_asper_oxy_isub" => "\u1F95",
"eta_lenis_bary_isub" => "\u1F92",
"eta_asper_bary_isub" => "\u1F93",
"eta_lenis_peri_isub" => "\u1F96",
"eta_asper_peri_isub" => "\u1F97",
"Eta_isub" => "\u1FCC",
"Eta_lenis_isub" => "\u1F98",
"Eta_asper_isub" => "\u1F99",
"Eta_lenis_oxy_isub" => "\u1F9C",
"Eta_asper_oxy_isub" => "\u1F9D",
"Eta_lenis_bary_isub" => "\u1F9A",
"Eta_asper_bary_isub" => "\u1F9B",
"Eta_lenis_peri_isub" => "\u1F9E",
"Eta_asper_peri_isub" => "\u1F9F",
"iota_oxy" => "\u1F77",
"iota_bary" => "\u1F76",
"iota_peri" => "\u1FD6",
"iota_lenis" => "\u1F30",
"iota_asper" => "\u1F31",
"iota_lenis_oxy" => "\u1F34",
"iota_asper_oxy" => "\u1F35",
"iota_lenis_bary" => "\u1F32",
"iota_asper_bary" => "\u1F33",
"iota_lenis_peri" => "\u1F36",
"iota_asper_peri" => "\u1F37",
"iota_diaer" => "\u03CA",
"iota_diaer_oxy" => "\u1FD3",
"iota_diaer_bary" => "\u1FD2",
"iota_diaer_peri" => "\u1FD7",
"Iota_oxy" => "\u1FDB",
"Iota_bary" => "\u1FDA",
"Iota_lenis" => "\u1F38",
"Iota_asper" => "\u1F39",
"Iota_lenis_oxy" => "\u1F3C",
"Iota_asper_oxy" => "\u1F3D",
"Iota_lenis_bary" => "\u1F3A",
"Iota_asper_bary" => "\u1F3B",
"Iota_lenis_peri" => "\u1F3E",
"Iota_asper_peri" => "\u1F3F",
"Iota_diaer" => "\u03AA",
"omicron_oxy" => "\u1F79",
"omicron_bary" => "\u1F78",
"omicron_lenis" => "\u1F40",
"omicron_asper" => "\u1F41",
"omicron_lenis_oxy" => "\u1F44",
"omicron_asper_oxy" => "\u1F45",
"omicron_lenis_bary" => "\u1F42",
"omicron_asper_bary" => "\u1F43",
"Omicron_oxy" => "\u1FF9",
"Omicron_bary" => "\u1FF8",
"Omicron_lenis" => "\u1F48",
"Omicron_asper" => "\u1F49",
"Omicron_lenis_oxy" => "\u1F4C",
"Omicron_asper_oxy" => "\u1F4D",
"Omicron_lenis_bary" => "\u1F4A",
"Omicron_asper_bary" => "\u1F4B",
"upsilon_oxy" => "\u1F7B",
"upsilon_bary" => "\u1F7A",
"upsilon_peri" => "\u1FE6",
"upsilon_lenis" => "\u1F50",
"upsilon_asper" => "\u1F51",
"upsilon_lenis_oxy" => "\u1F54",
"upsilon_asper_oxy" => "\u1F55",
"upsilon_lenis_bary" => "\u1F52",
"upsilon_asper_bary" => "\u1F53",
"upsilon_lenis_peri" => "\u1F56",
"upsilon_asper_peri" => "\u1F57",
"upsilon_diaer" => "\u03CB",
"upsilon_diaer_oxy" => "\u1FE3",
"upsilon_diaer_bary" => "\u1FE2",
"upsilon_diaer_peri" => "\u1FE7",
"Upsilon_oxy" => "\u1FEB",
"Upsilon_bary" => "\u1FEA",
"Upsilon_asper" => "\u1F59",
"Upsilon_asper_oxy" => "\u1F5D",
"Upsilon_asper_bary" => "\u1F5B",
"Upsilon_asper_peri" => "\u1F5F",
"Upsilon_diaer" => "\u03AB",
"omega_oxy" => "\u1F7D",
"omega_bary" => "\u1F7C",
"omega_peri" => "\u1FF6",
"omega_lenis" => "\u1F60",
"omega_asper" => "\u1F61",
"omega_lenis_oxy" => "\u1F64",
"omega_asper_oxy" => "\u1F65",
"omega_lenis_bary" => "\u1F62",
"omega_asper_bary" => "\u1F63",
"omega_lenis_peri" => "\u1F66",
"omega_asper_peri" => "\u1F67",
"Omega_oxy" => "\u1FFB",
"Omega_bary" => "\u1FFA",
"Omega_lenis" => "\u1F68",
"Omega_asper" => "\u1F69",
"Omega_lenis_oxy" => "\u1F6C",
"Omega_asper_oxy" => "\u1F6D",
"Omega_lenis_bary" => "\u1F6A",
"Omega_asper_bary" => "\u1F6B",
"Omega_lenis_peri" => "\u1F6E",
"Omega_asper_peri" => "\u1F6F",
"omega_isub" => "\u1FF3",
"omega_oxy_isub" => "\u1FF4",
"omega_bary_isub" => "\u1FF2",
"omega_peri_isub" => "\u1FF7",
"omega_lenis_isub" => "\u1FA0",
"omega_asper_isub" => "\u1FA1",
"omega_lenis_oxy_isub" => "\u1FA4",
"omega_asper_oxy_isub" => "\u1FA5",
"omega_lenis_bary_isub" => "\u1FA2",
"omega_asper_bary_isub" => "\u1FA3",
"omega_lenis_peri_isub" => "\u1FA6",
"omega_asper_peri_isub" => "\u1FA7",
"Omega_isub" => "\u1FFC",
"Omega_lenis_isub" => "\u1FA8",
"Omega_asper_isub" => "\u1FA9",
"Omega_lenis_oxy_isub" => "\u1FAC",
"Omega_asper_oxy_isub" => "\u1FAD",
"Omega_lenis_bary_isub" => "\u1FAA",
"Omega_asper_bary_isub" => "\u1FAB",
"Omega_lenis_peri_isub" => "\u1FAE",
"Omega_asper_peri_isub" => "\u1FAF",

"space" => "\u0020",
"prime" => "\u0374",
"raisedDot"  => "\u0387",
"semicolon" => "\u037E",
"elisionMark" => "\u1FBD",
"comma" => "\u002C",
"period" => "\u002E",
"hyphen" => "\u002D",

"openingSquareBracket" => "\u005B",
"closingSquareBracket" => "\u005D",
"openingParentheses" => "\u0028",
"closingParentheses" => "\u0029",
"openingAngleBracket" => "\u2329",
"closingAngleBracket" => "\u232A",
"openingCurlyBracket" => "\u007B",
"closingCurlyBracket" => "\u007D",
"openingDoubleSquareBracket" => "\u27E6",
"closingDoubleSquareBracket" => "\u27E7",
"crux" => "\u2020",
"asterisk" => "\u002A",
"longVerticalBar" => "\u007C",
]

#As far as I can tell, there are no tonos + breathings or iota subscript 
#combinations bc tonos was a symbol for modern not polytonic greek
#if that is true, this table should be comprehensive
TONOS_TO_OXIA_TABLE = Hash[
#tonos   => #oxia
"\u0386" => "\u1FBB", #capital letter alpha
"\u0388" => "\u1FC9", #capital letter epsilon       
"\u0389" => "\u1FCB", #capital letter eta
"\u038C" => "\u1FF9", #capital letter omicron
"\u038A" => "\u1FDB", #capital letter iota
"\u038E" => "\u1FF9", #capital letter upsilon
"\u038F" => "\u1FFB", #capital letter omega
                
"\u03AC" => "\u1F71", #small letter alpha
"\u03AD" => "\u1F73", #small letter epsilon
"\u03AE" => "\u1F75", #small letter eta
"\u0390" => "\u1FD3", #small letter iota with dialytika and tonos/oxia
"\u03AF" => "\u1F77", #small letter iota
"\u03CC" => "\u1F79", #small letter omicron
"\u03B0" => "\u1FE3", #small letter upsilon with with dialytika and tonos/oxia
"\u03CD" => "\u1F7B", #small letter upsilon
"\u03CE" => "\u1F7D"  #small letter omega
]

OXIA_TO_TONOS_TABLE ||= TONOS_TO_OXIA_TABLE.invert
REVERSE_BETA_CODES  ||= BETA_CODES.invert
REVERSE_UNICODES    ||= UNICODES.invert
VALID_UNICODE       ||= REVERSE_UNICODES
SHARED_TOKENS         = (UNICODES.values & BETA_CODES.keys).map { |v|  BETA_CODES[v] }
end#EOC
end#EOM