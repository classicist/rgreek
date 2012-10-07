# encoding: UTF-8
require 'spec_helper'

describe "Database Integrity Wishlist Checks" do
#  it "should be matched by every Lemma's unicode_headword (there are about twice as may LsjEntries as Lemmas)" do
#    pending
#    Lemma.find(:all).each { |l| LsjEntry.find_by_headword(l.unicode_headword).should_not be_nil, l}
#  end
#
#  it "should find an entry with greek copied from db betacode (check for encoding issues)" do
#    pending
#    greek_copied_from_db = "καί"
#    LsjEntry.find_by_headword(greek_copied_from_db).headword.should == greek_copied_from_db
#  end
#  
#  it "should find an entry with greek typed from the keyboard (check for encoding issues)" do
#    pending
#    typed_greek = "καί"
#    entry = LsjEntry.find_by_headword(typed_greek)
#    entry.should_not == nil
#    entry.headword.should == typed_greek    
#  end
#  it "should have at least one parse" do
#    pending
#    #have to do this in sql bc of speed; 
#    #there are 4218 unparsed Lemmas in the DB
#    #@all_greek_lemmas.map { |l| l.parses.length == 0}.length.should == 0
#  end
#  
#  it "should have a short_def if it is a greek word" do
#    pending
#    # 2142 greek lemmas fail this test 
#  end
#  
#  it "should have at least one lsj_entry" do
#    pending
#    #3078 lemmas have no lsj entry
#  end
end