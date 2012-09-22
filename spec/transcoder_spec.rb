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
  
  it "should give the name of a betacode token for longum and breve" do
    Transcoder.tokenize("%40%41").should == ["longum", "breve"]    
  end
  
  it "should give the name of a betacode token for crazy sigma" do
    Transcoder.tokenize("S1S2S3").should == ["sigmaMedial","sigmaFinal", "sigmaLunate"]
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
    Transcoder.convert("kai/").should == "και"
  end
end