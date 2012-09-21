# encoding: UTF-8
require "spec_helper"

describe "rGreek" do
  it "should do exist" do
    Lemma.new.should_not be_nil
    Parse.new.should_not be_nil    
  end
  
  it "should get all parses for a lemma" do
    lemma = Lemma.find_by_headword "kai/"
    parses = Parse.find_all_by_lemma_id lemma.id
    puts parses.to_yaml
    parses.length.should == 1
  end
end