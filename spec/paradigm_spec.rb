require 'spec_helper'

describe Paradigm do
  before(:each) do
    @lemma     =  Lemma.find_all_by_headword("le/gw")[2] #to say, speak
    @paradigm  = Paradigm.new @lemma
  end
  
  it "should have a lemma" do
    @paradigm.lemma.should == @lemma
  end
  
  it "should have all the parses for that lemma" do
    @paradigm.parses.length.should == 709
  end
  
  it "should print each of the parses out in order" do
    pending
    @paradigm.print.should == "moo"
  end
end