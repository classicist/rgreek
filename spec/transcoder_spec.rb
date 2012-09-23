# encoding: UTF-8

require File.dirname(__FILE__) + '/spec_helper'

describe "The Betacode Tokenizer" do
  it "should give the name of a betacode token for the regular alphabet" do
    Transcoder.tokenize("a").should == ["alpha"]
    Transcoder.tokenize("w").should == ["omega"]    
  end
  
  it "should give the name of three betacode tokens in the regular alphabet" do
    Transcoder.tokenize("abg").should == ["alpha", "beta", "gamma"]
  end

  it "should give the name of a betacode token for capitals" do
    Transcoder.tokenize("*a").should == ["Alpha"]   
    Transcoder.tokenize("e*ab*g").should == ["epsilon", "Alpha", "beta", "Gamma"]   
  end

  it "should give the name of a betacode token for accents" do
    Transcoder.tokenize("/").should == ["oxy"]
    Transcoder.tokenize("*kai/").should == ["Kappa", "alpha", "iota", "oxy"]
  end
  
  it "should give the name of a betacode token for crazy sigma" do
    Transcoder.tokenize("SS2S3").should == ["sigmaMedial","sigmaFinal", "sigmaLunate"]
    Transcoder.tokenize("S3*S3").should == ["sigmaLunate", "SigmaLunate"]
  end

  it "should give the name of a betacode token for koppa, sampi, and stigma" do
    Transcoder.tokenize("#3*#3*#5#5#2*#2").should == ["koppa","Koppa", "Sampi", "sampi", "stigma", "Stigma"]
  end

  it "should give the name of a betacode token for punctuation" do
    Transcoder.tokenize("#\:;\'").should == ["prime","raisedDot", "semicolon", "elisionMark"]
  end
  
  it "should give the name of a betacode token for Brackets and the like" do
    Transcoder.tokenize("[][1]1[2]2[3]3[4]4").should == ["openingSquareBracket","closingSquareBracket", "openingParentheses", "closingParentheses", "openingAngleBracket", "closingAngleBracket", "openingCurlyBracket", "closingCurlyBracket", "openingDoubleSquareBracket", "closingDoubleSquareBracket"]
  end
  
  it "should give the name of a betacode token for critical marks" do
    Transcoder.tokenize("%%2%5").should == ["crux", "asterisk", "longVerticalBar"]
  end
end

describe "Betacode to Unicode C Conversion" do
  
  it "should convert betacode letters to unicode without greek accents" do
    Transcoder.betacode_to_unicode("kai").should == "και"
  end
  
  it "should convert betacode letters to unicode with combined greek accents over vowels" do
    Transcoder.betacode_to_unicode("le/gw").should == "λέγω"
    Transcoder.betacode_to_unicode("kai/").should == "καί"
  end
  
  it "should convert betacode letters to unicode with combined greek accents over vowels with breathing marks, spaces, and wierd punctuation" do
    Transcoder.betacode_to_unicode("pw=s ").should == "πῶς "  
    Transcoder.betacode_to_unicode("pw=s").should == "πῶς"    
    Transcoder.betacode_to_unicode("[4*h)/xw]4\:").should == "⟦Ἤχω⟧·"
    Transcoder.betacode_to_unicode("*h)/xw au)tw=|").should == "Ἤχω αὐτῷ"
    Transcoder.betacode_to_unicode("gnw=qi %5 seau/ton%").should == "γνῶθι | σεαύτον†"    
  end
  
  it "should convert unicode to betacode" do
    pending
    Transcoder.unicode_to_betacode("πῶς ").should == "pw=s "
    Transcoder.unicode_to_betacode("πῶς").should == "pw=s"
    Transcoder.unicode_to_betacode("⟦Ἤχω⟧·").should == "[4*h)/xw]4\:"
    Transcoder.unicode_to_betacode("Ἤχω αὐτῷ").should == "*h)/xw au)tw=|"
    Transcoder.unicode_to_betacode("γνῶθι | σεαύτον†").should == "gnw=qi %5 seau/ton%"
  end
  
  it "should change all known betacode tokens to unicode" do    
      unicodes = Transcoder.convert_to_unicode(Transcoder::BETA_CODES.values)
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

  it "should change all known unicode chars to betacode and back without loss" do    
        pending    
      all_known_unicode_chars = Transcoder::UNICODES.values.join      
      betacodes = Transcoder.unicode_to_betacode(all_known_unicode_chars)      
      result_unicode = Transcoder.betacode_to_unicode(betacodes)
      (all_known_unicode_chars.split("") - result_unicode.split("")).map do |unicode|
        Transcoder.name_of_unicode_char(unicode)
      end.should == []
  end

end