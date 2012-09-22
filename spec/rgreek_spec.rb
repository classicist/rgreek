# encoding: UTF-8
require "spec_helper"

describe "rGreek" do
  it "should do exist" do
    Lemma.new.should_not be_nil
    Parse.new.should_not be_nil    
  end
  
  it "should get all parses for kai/" do
    lemma = Lemma.find_by_headword "kai/"
    parses = Parse.find_all_by_lemma_id lemma.id
    parses.length.should == 5
  end
  
  it "should detect accents" do
    Parse.has_accents?("moo").should == false
    Parse.has_accents?("le/gw").should == true
  end
  
  it "should find a word using accents if it has them or not if it doesn't" do
    Parse.find_parses("kai/").length.should == 1
    Parse.find_parses("le/gw").length.should == 7    
    Parse.find_parses("kai").length.should == 12
  end
  
  it "should translate the morph_code into english" do
    parse = Parse.find_parses("le/gw").first
    parse.morph_code.should == "v1spsa---"
    parse.morph_code_pretty.should == "verb 1st sg pres subj act"
    
    parse = Parse.find_parses("po/lis").first
    parse.morph_code.should == "n-s---fn-"
    parse.morph_code_pretty.should == "noun sg fem nom"
    
    parse = Parse.find_parses("kai/").first
    parse.morph_code.should == "c--------"
    parse.morph_code_pretty.should == "conj indeclinable"    
  end
  
  it "should sort parse results by dialect" do
    parse = Parse.find_parses("po/lis").first
    parse.dialects.should == nil
    parse.morph_code.should == "n-s---fn-"  # "noun sg fem nom"

    parse = Parse.find_parses("po/lis")[1]
    parse.morph_code.should == "n-p---fa-" # "noun pl fem acc" <- epic, doric, etc.
  end
end