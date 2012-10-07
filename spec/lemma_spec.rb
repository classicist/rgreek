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
end