# encoding: UTF-8
require 'spec_helper'

describe "LsjEntry headwords" do
  it "should find an entry with greek copied from db betacode (check for encoding issues)" do
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