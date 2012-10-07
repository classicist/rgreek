# encoding: UTF-8
require 'spec_helper'

describe "Lemma" do
  before(:each) do
    @greek = Lemma.find_by_headword "kai/"    
    @latin = Lemma.find_by_headword "sed"    
  end
  
  it "should exist" do
    Lemma.new.should_not be_nil
    Parse.new.should_not be_nil    
  end
  
  it "should have a unicode headword" do
    @greek.unicode_headword.should_not be_nil
    @latin.unicode_headword.should_not be_nil    
  end
  
  it "should tell you what language it is" do    
    @greek.lang.should == "greek"
    @latin.lang.should == "latin"    
  end
  
  it "should find all lemmas lacking a short_def" do
    lackers = Lemma.find_all_lacking_short_def
    lackers.length.should > 0
  end
end