# encoding: UTF-8
require 'spec_helper'

describe "Lemma" do
  before(:all) do
    @all_greek_lemmas = Lemma.greek
  end
  
  it "should exist" do
    Lemma.new.should_not be_nil
    Parse.new.should_not be_nil    
  end
  
  it "should get all parses for kai/" do
    lemma = Lemma.find_by_headword "kai/"
    parses = Parse.find_all_by_lemma_id lemma.id
    parses.length.should == 5
  end
  
  it "should have at least one parse" do
    pending
    #have to do this in sql bc of speed; 
    #there are 4218 unparsed Lemmas in the DB
    #@all_greek_lemmas.map { |l| l.parses.length == 0}.length.should == 0
  end
  
  it "should have a short_def if it is a greek word" do
    pending
    # 2142 greek lemmas fail this test 
  end
  
  it "should have at least one lsj_entry" do
    pending
    #3078 lemmas have no lsj entry
  end
end