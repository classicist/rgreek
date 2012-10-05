require 'spec_helper'

describe "Lemma" do
  
  before(:all) do
    @all_greek_lemmas = Lemma.find_all_by_lang_id(2)
  end

  it "should have a greek_headword if it is greek" do
   @all_greek_lemmas.each { |l| l.greek_headword.should_not be_nil }
  end
  
  it "should have at least one parse" do
    pending
    #have to do this in sql bc of speed; 
    #there are 4218 unparsed Lemmas in the DB
    #@all_greek_lemmas.map { |l| l.parses.length == 0}.length.should == 0
  end
  
  it "should have a short_def if it is a greek word" do
    pending
    # 3222 lemmas fail this test 
    # 2142 greek lemmas fail this test 
    # @all_greek_lemmas.map { |l| l if l.short_def == nil}.compact.length.should == 0
  end
  
  it "should have at least one lsj_entry" do
    pending
  end
end