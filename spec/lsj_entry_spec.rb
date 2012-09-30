# encoding: UTF-8
require 'spec_helper'

describe "LsjEntry headwords" do
  it "should be matched by every Lemma's greek_headword (there are about twice as may LsjEntries as Lemmas)" do
    pending
    Lemma.find(:all).each { |l| LsjEntry.find_by_headword(l.greek_headword).should_not be_nil, l}
  end

  it "should not contain a tonos" do
    pending
    LsjEntry.find(:all).each { |e| e.headword.should_not contain_tonos}
  end

  it "should find an entry with greek copied from db betacode (check for encoding issues)" do
    pending
    greek_copied_from_db = "καί"
    LsjEntry.find_by_headword(greek_copied_from_db).headword.should == greek_copied_from_db
  end
  
  it "should find an entry with greek typed from the keyboard (check for encoding issues)" do
    pending
    typed_greek = "καί"
    entry = LsjEntry.find_by_headword(typed_greek)
    entry.should_not == nil
    entry.headword.should == typed_greek    
  end
end