# encoding: UTF-8

require 'spec_helper'

describe "The Betacode Tokenizer" do
  it "should give the name of a betacode token for the regular alphabet" do
    Transcoder.send(:tokenize, "a").should == ["alpha"]
    Transcoder.send(:tokenize, "w").should == ["omega"]    
  end
  
  it "should give the name of three betacode tokens in the regular alphabet" do
    Transcoder.send(:tokenize, "abg").should == ["alpha", "beta", "gamma"]
  end

  it "should give the name of a betacode token for capitals" do
    Transcoder.send(:tokenize, "*a").should == ["Alpha"]   
    Transcoder.send(:tokenize, "e*ab*g").should == ["epsilon", "Alpha", "beta", "Gamma"]   
  end

  it "should give the name of a betacode token for accents" do
    Transcoder.send(:tokenize, "/").should == ["oxy"]
    Transcoder.send(:tokenize, "*kai/").should == ["Kappa", "alpha", "iota", "oxy"]
  end
  
  it "should give the name of a betacode token for crazy sigma" do
    Transcoder.send(:tokenize, "SS2S3").should == ["sigmaMedial","sigmaFinal", "sigmaLunate"]
    Transcoder.send(:tokenize, "S3*S3").should == ["sigmaLunate", "SigmaLunate"]
  end

  it "should give the name of a betacode token for koppa, sampi, and stigma" do
    Transcoder.send(:tokenize, "#3*#3*#5#5#2*#2").should == ["koppa","Koppa", "Sampi", "sampi", "stigma", "Stigma"]
  end

  it "should give the name of a betacode token for punctuation" do
    Transcoder.send(:tokenize, "#\:;\'").should == ["prime","raisedDot", "semicolon", "elisionMark"]
  end
  
  it "should give the name of a betacode token for Brackets and the like" do
    Transcoder.send(:tokenize, "[][1]1[2]2[3]3[4]4").should == ["openingSquareBracket","closingSquareBracket", "openingParentheses", "closingParentheses", "openingAngleBracket", "closingAngleBracket", "openingCurlyBracket", "closingCurlyBracket", "openingDoubleSquareBracket", "closingDoubleSquareBracket"]
  end
  
  it "should give the name of a betacode token for critical marks" do
    Transcoder.send(:tokenize, "%%2%5").should == ["crux", "asterisk", "longVerticalBar"]
  end
end

describe "Betacode to Unicode C Conversion" do
  
  it "should convert betacode letters to unicode with combined greek accents over vowels with breathing marks, spaces, and wierd punctuation" do
    Transcoder.convert("*s").should == "Σ"    
    Transcoder.convert("pw=s, a.").should == "πῶς, α."  
    Transcoder.convert("pw=s ").should == "πῶς "  
    Transcoder.convert("pw=s").should == "πῶς"    
    Transcoder.convert("[4*h)/xw]4\:").should == "⟦Ἤχω⟧·"
    Transcoder.convert("*h)/xw au)tw=|").should == "Ἤχω αὐτῷ"
    Transcoder.convert("gnw=qi %5 seau/ton%").should == "γνῶθι | σεαύτον†"    
  end
  
  it "should convert betacode letters to unicode without greek accents" do
    Transcoder.convert("kai").should == "και"
  end
  
  it "should convert betacode letters to unicode with combined greek accents over vowels" do
    Transcoder.convert("le/gw").should == "λέγω"
    Transcoder.convert("kai/").should == "καί"
  end
  
  it "should convert unicode to betacode" do
    Transcoder.convert("Σ").should == "*s"
    Transcoder.convert("πῶς ").should == "pw=s "
    Transcoder.convert("πῶς").should == "pw=s"
    Transcoder.convert("⟦Ἤχω⟧·").should == "[4*h)/xw]4\:"
    Transcoder.convert("Ἤχω αὐτῷ").should == "*h)/xw au)tw=|"
    Transcoder.convert("γνῶθι | σεαύτον†").should == "gnw=qi %5 seau/ton%"
  end
  
  it "should change all known betacode tokens to unicode" do    
      unicodes = Transcoder.send(:convert_to_unicode, (Transcoder::BETA_CODES.values))
      unicodes.length.should > 0
      unicodes.split("").each do |code|
        Transcoder::REVERSE_UNICODES[code].should_not == nil        
      end
  end

  it "should reverse the betacode and unicode transcoding hashes without loss" do
      Transcoder::BETA_CODES.keys.should == Transcoder::REVERSE_BETA_CODES.values
      Transcoder::UNICODES.keys.should == Transcoder::REVERSE_UNICODES.values
      
      Transcoder::BETA_CODES.values.should == Transcoder::REVERSE_BETA_CODES.keys
      Transcoder::UNICODES.values.should == Transcoder::REVERSE_UNICODES.keys
  end
  
  it "should change roundtrip betacode -> unicode -> betacode for all known betacodes except final sigma" do
      all_known_betacode_chars = Transcoder::BETA_CODES.keys.join(",")      
      unicodes = Transcoder.convert(all_known_betacode_chars)      
      result_betacode = Transcoder.convert(unicodes)
      
    #Final Sigma ("s2") appears to be lost, but is not because we test for it by position so that we can return regular "s" in our 
    #generated betacode than the anoying-to-read "s2"     
      (all_known_betacode_chars.split(",") - result_betacode.split(",")).sort.should == ["s2"]   
  end

  it "should change roundtrip unicode -> betacode -> unicode for all known betacodes except final sigma" do
      all_known_unicode_chars = Transcoder::UNICODES.values.join       
      betacodes = Transcoder.convert(all_known_unicode_chars)      
      result_unicode = Transcoder.convert(betacodes)
      (all_known_unicode_chars.split("") - result_unicode.split("")).map do |unicode|
        Transcoder.name_of_unicode_char(unicode)
      end.should == ["sigmaFinal"] #sigmaFinal should be missing bc we never print "s2" (reciprocal with above)       
  end
  
  it "should transcode sigma and final sigma correctly based on position or value" do
      Transcoder.convert("ς").should_not == "s2" #never output s2
      Transcoder.convert("ς").should == "s" 
      Transcoder.convert("σα").should == "sa"     

      Transcoder.convert("s2").should == "ς"      
      Transcoder.convert("s").should == "ς"       
      Transcoder.convert("sa").should == "σα"     
  end
  
  it "should detect whether the input is beta or unicode" do
    beta, uni = "kai/", "καί"
    Transcoder.is_betacode?(beta).should == true
    Transcoder.is_betacode?(uni).should == false

    Transcoder.is_unicode?(uni).should == true
    Transcoder.is_unicode?(beta).should == false
     
    Transcoder.is_betacode?(Transcoder::BETA_CODES.keys.join).should == true
    Transcoder.is_betacode?(Transcoder::UNICODES.values.join).should == false
    
    Transcoder.is_unicode?(Transcoder::UNICODES.values.join).should == true     
    Transcoder.is_unicode?(Transcoder::BETA_CODES.keys.join).should == false      
  end
  
  it "should detect accents" do
    Transcoder.has_accents?("moo").should == false
    Transcoder.has_accents?("le/gw").should == true
  end
  
  it "should should automatically transcode beta and unicode" do
    beta, uni = "kai/s", "καίς"
    Transcoder.convert(beta).should == uni
    Transcoder.convert(uni).should == beta            
  end
end

describe "Tonos converter" do
  it "should transcode tonos accents to oxias" do
    oxia  = "ί"
    tonos = "ί"
    tonos.should === "\u03af"
    Transcoder.tonos_to_oxia(tonos).should == oxia
  end
  
  it "should convert a word with tonoi to a word with oxiai without screwing up the uninvolved chars" do
    kaiw_oxia = "καίω"
    kaiw_tonos = "καίω"
    kaiw_oxia.should_not == kaiw_tonos
    Transcoder.tonos_to_oxia(kaiw_tonos).should == kaiw_oxia
  end
  
  it "should not hurt words that do not have a tonos in them" do
    kaiw_oxia = "καίωbaldinadfioadfm2<>\.o4./+-1[}{]"
    Transcoder.tonos_to_oxia(kaiw_oxia).should == kaiw_oxia
  end
  
  it "should transcode omega with tonos to omega with oxia" do
    tonos_omega = "ώ"
    oxia_omega  = "ώ"
    Transcoder.tonos_to_oxia(tonos_omega).should == oxia_omega
  end

# => only run when database is updated and greek or latin lemmas are added  
#  it "should find all greek lemmas" do
#    GreekLemma.find(:all).map { |l| l.headword if !Transcoder.is_greek?(l.headword)  }.compact.should == []
#  end
#
end