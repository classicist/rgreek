# encoding: UTF-8
require 'spec_helper'

describe "Lemma" do
  before(:each) do
    @greek = GreekLemma.find_by_headword "kai/"    
    @latin = LatinLemma.find_by_headword "sed"    
  end
  
  it "should exist" do
    GreekLemma.new.should_not be_nil
    LatinLemma.new.should_not be_nil
  end
  
  it "should find all lemmas lacking a short_def" do
    lackers = LatinLemma.find_all_lacking_short_def
    lackers.length.should > 0
  end

  it "should have different parses" do
    ls = GreekLemma.find_all_by_headword("le/gw")
    ls[2].parses.length.should_not == ls[1].parses.length
  end  
end